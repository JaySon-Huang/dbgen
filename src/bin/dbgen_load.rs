use clap::Parser;
use flate2::read::MultiGzDecoder;
use mysql::{Conn, OptsBuilder, Params, Statement, TxOpts, Value, prelude::Queryable};
use serde::{Deserialize, Serialize};
use std::{
    error::Error,
    ffi::OsStr,
    fs::{self, File},
    io::{BufReader, Write},
    path::{Path, PathBuf},
    time::{Duration, Instant},
};

type DynResult<T> = Result<T, Box<dyn Error>>;

const DEFAULT_BATCH_SIZE: usize = 1_000;
const MYSQL_MAX_PARAMETERS: usize = 65_535;

#[derive(Debug, Parser)]
#[command(about = "Stream dbgen gzip CSV files into TiDB in deterministic order")]
struct Args {
    /// Directory containing headerless *.csv.gz files.
    #[arg(long)]
    input_dir: PathBuf,

    /// File prefix before the dbgen numeric suffix.
    #[arg(long, default_value = "bc_bet_records_213")]
    file_prefix: String,

    /// TiDB host.
    #[arg(long, default_value = "127.0.0.1")]
    host: String,

    /// TiDB MySQL protocol port.
    #[arg(long, default_value_t = 4000)]
    port: u16,

    /// TiDB user.
    #[arg(long, default_value = "root")]
    user: String,

    /// TiDB password. TIDB_PASSWORD is used when this option is omitted.
    #[arg(long)]
    password: Option<String>,

    /// Default target database.
    #[arg(long)]
    database: String,

    /// Target table, either table or database.table.
    #[arg(long)]
    table: String,

    /// Rows in each multi-value INSERT.
    #[arg(long, default_value_t = DEFAULT_BATCH_SIZE)]
    batch_size: usize,

    /// Optional local checkpoint file. Resume replays gzip input and skips committed rows.
    #[arg(long)]
    checkpoint: Option<PathBuf>,

    /// Validate files, target schema, and generated INSERT shape without writing rows.
    #[arg(long)]
    dry_run: bool,

    /// Allow loading into a non-empty table. Disabled by default to prevent duplicates.
    #[arg(long)]
    allow_nonempty: bool,

    /// Progress reporting interval in seconds.
    #[arg(long, default_value_t = 10)]
    report_every: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
struct Checkpoint {
    manifest: String,
    target: String,
    committed_rows: u64,
    committed_batches: u64,
    complete: bool,
}

#[derive(Debug)]
struct Target {
    database: String,
    table: String,
}

#[derive(Debug)]
struct Progress {
    started_at: Instant,
    last_report_at: Instant,
    report_every: Duration,
    committed_rows: u64,
    committed_batches: u64,
}

impl Progress {
    fn new(report_every: Duration, committed_rows: u64, committed_batches: u64) -> Self {
        let now = Instant::now();
        Self {
            started_at: now,
            last_report_at: now,
            report_every,
            committed_rows,
            committed_batches,
        }
    }

    fn committed(&mut self, rows: usize, file: &Path) {
        self.committed_rows += rows as u64;
        self.committed_batches += 1;
        let now = Instant::now();
        if now.duration_since(self.last_report_at) >= self.report_every {
            let elapsed = now.duration_since(self.started_at).as_secs_f64().max(0.001);
            eprintln!(
                "progress: rows={} batches={} rate={:.1} rows/s file={}",
                self.committed_rows,
                self.committed_batches,
                self.committed_rows as f64 / elapsed,
                file.display()
            );
            self.last_report_at = now;
        }
    }
}

fn main() {
    if let Err(error) = run(Args::parse()) {
        eprintln!("dbgen-load failed: {error}");
        std::process::exit(1);
    }
}

fn run(args: Args) -> DynResult<()> {
    if args.batch_size == 0 {
        return Err("--batch-size must be greater than zero".into());
    }
    if args.report_every == 0 {
        return Err("--report-every must be greater than zero".into());
    }

    let files = discover_files(&args.input_dir, &args.file_prefix)?;
    let manifest = dataset_manifest(&files)?;
    let target = parse_target(&args.database, &args.table)?;
    let target_name = format!("{}.{}", target.database, target.table);
    let checkpoint = load_checkpoint(args.checkpoint.as_deref())?;
    if let Some(checkpoint) = &checkpoint {
        validate_checkpoint(checkpoint, &manifest, &target_name)?;
        if checkpoint.complete {
            return Err(format!("checkpoint already marks {target_name} as complete").into());
        }
    }

    let password = args
        .password
        .or_else(|| std::env::var("TIDB_PASSWORD").ok())
        .unwrap_or_default();
    let opts = OptsBuilder::default()
        .ip_or_hostname(Some(args.host))
        .tcp_port(args.port)
        .user(Some(args.user))
        .pass(Some(password))
        .db_name(Some(target.database.clone()));
    let mut conn = Conn::new(opts)?;

    let columns = load_target_columns(&mut conn, &target)?;
    if columns.is_empty() {
        return Err(format!("target table {target_name} does not exist or has no writable columns").into());
    }
    validate_parameter_count(columns.len(), args.batch_size)?;

    let existing_rows = target_row_count(&mut conn, &target)?;
    let resume_rows = checkpoint.as_ref().map_or(0, |value| value.committed_rows);
    let resume_batches = checkpoint.as_ref().map_or(0, |value| value.committed_batches);
    if checkpoint.is_some() {
        if existing_rows != resume_rows {
            return Err(format!(
                "checkpoint records {resume_rows} rows, but target contains {existing_rows}; refusing unsafe resume"
            )
            .into());
        }
    } else if existing_rows != 0 && !args.allow_nonempty {
        return Err(format!(
            "target table {target_name} is not empty ({existing_rows} rows); use --allow-nonempty only if this is intentional"
        )
        .into());
    }

    let full_insert_sql = build_insert_sql(&target, &columns, args.batch_size);
    let full_statement = if args.dry_run {
        None
    } else {
        Some(conn.prep(full_insert_sql)?)
    };

    eprintln!(
        "loading: files={} target={} columns={} batch_size={} resume_rows={} dry_run={}",
        files.len(),
        target_name,
        columns.len(),
        args.batch_size,
        resume_rows,
        args.dry_run
    );

    let mut progress = Progress::new(Duration::from_secs(args.report_every), resume_rows, resume_batches);
    let mut seen_rows = 0_u64;
    let mut pending_rows = 0_usize;
    let mut pending_values = Vec::with_capacity(args.batch_size * columns.len());
    let mut last_file = files[0].as_path();

    for file in &files {
        last_file = file;
        let input = BufReader::new(File::open(file)?);
        let decoder = MultiGzDecoder::new(input);
        let mut reader = csv::ReaderBuilder::new().has_headers(false).from_reader(decoder);

        for record in reader.byte_records() {
            let record = record.map_err(|error| format!("read {}: {error}", file.display()))?;
            seen_rows += 1;
            if seen_rows <= resume_rows {
                continue;
            }
            if record.len() != columns.len() {
                return Err(format!(
                    "{} row {} has {} fields, target has {} columns",
                    file.display(),
                    seen_rows,
                    record.len(),
                    columns.len()
                )
                .into());
            }
            append_record_values(&record, &mut pending_values);
            pending_rows += 1;

            if pending_rows == args.batch_size {
                if let Some(statement) = &full_statement {
                    execute_batch(&mut conn, statement, std::mem::take(&mut pending_values))?;
                } else {
                    pending_values.clear();
                }
                progress.committed(pending_rows, file);
                pending_rows = 0;
                if !args.dry_run {
                    persist_progress(args.checkpoint.as_deref(), &manifest, &target_name, &progress, false)?;
                }
                pending_values.reserve(args.batch_size * columns.len());
            }
        }
    }

    if seen_rows < resume_rows {
        return Err(format!("checkpoint skips {resume_rows} rows, but dataset contains only {seen_rows}").into());
    }

    if pending_rows != 0 {
        if !args.dry_run {
            let tail_sql = build_insert_sql(&target, &columns, pending_rows);
            let tail_statement = conn.prep(tail_sql)?;
            execute_batch(&mut conn, &tail_statement, std::mem::take(&mut pending_values))?;
        }
        progress.committed(pending_rows, last_file);
    }

    if !args.dry_run {
        persist_progress(args.checkpoint.as_deref(), &manifest, &target_name, &progress, true)?;
    }

    let elapsed = progress.started_at.elapsed().as_secs_f64().max(0.001);
    eprintln!(
        "done: rows={} batches={} elapsed={elapsed:.1}s average={:.1} rows/s dry_run={}",
        progress.committed_rows,
        progress.committed_batches,
        (progress.committed_rows - resume_rows) as f64 / elapsed,
        args.dry_run
    );
    Ok(())
}

fn discover_files(input_dir: &Path, prefix: &str) -> DynResult<Vec<PathBuf>> {
    if prefix.is_empty() {
        return Err("--file-prefix must not be empty".into());
    }
    let prefix_with_dot = format!("{prefix}.");
    let mut files = fs::read_dir(input_dir)?
        .filter_map(Result::ok)
        .map(|entry| entry.path())
        .filter(|path| {
            let Some(name) = path.file_name().and_then(OsStr::to_str) else {
                return false;
            };
            path.is_file() && name.starts_with(&prefix_with_dot) && name.ends_with(".csv.gz")
        })
        .collect::<Vec<_>>();
    files.sort();
    if files.is_empty() {
        return Err(format!("no {prefix}.*.csv.gz files found in {}", input_dir.display()).into());
    }
    Ok(files)
}

fn dataset_manifest(files: &[PathBuf]) -> DynResult<String> {
    let mut manifest = String::new();
    for file in files {
        let name = file
            .file_name()
            .and_then(OsStr::to_str)
            .ok_or_else(|| format!("non-UTF-8 file name: {}", file.display()))?;
        let size = fs::metadata(file)?.len();
        manifest.push_str(name);
        manifest.push(':');
        manifest.push_str(&size.to_string());
        manifest.push('\n');
    }
    Ok(manifest)
}

fn parse_target(default_database: &str, input: &str) -> DynResult<Target> {
    let parts = input.split('.').collect::<Vec<_>>();
    let (database, table) = match parts.as_slice() {
        [table] => (default_database, *table),
        [database, table] => (*database, *table),
        _ => return Err("--table must be table or database.table".into()),
    };
    validate_identifier(database)?;
    validate_identifier(table)?;
    Ok(Target {
        database: database.to_owned(),
        table: table.to_owned(),
    })
}

fn validate_identifier(identifier: &str) -> DynResult<()> {
    if identifier.is_empty()
        || !identifier
            .bytes()
            .all(|byte| byte.is_ascii_alphanumeric() || byte == b'_' || byte == b'$')
    {
        return Err(format!("unsafe SQL identifier: {identifier:?}").into());
    }
    Ok(())
}

fn quoted_target(target: &Target) -> String {
    format!("`{}`.`{}`", target.database, target.table)
}

fn load_target_columns(conn: &mut Conn, target: &Target) -> DynResult<Vec<String>> {
    Ok(conn.exec_map(
        "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS \
         WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? \
           AND COALESCE(GENERATION_EXPRESSION, '') = '' \
         ORDER BY ORDINAL_POSITION",
        (&target.database, &target.table),
        |column: String| column,
    )?)
}

fn target_row_count(conn: &mut Conn, target: &Target) -> DynResult<u64> {
    conn.query_first(format!("SELECT COUNT(*) FROM {}", quoted_target(target)))?
        .ok_or_else(|| "COUNT(*) returned no row".into())
}

fn validate_parameter_count(columns: usize, batch_size: usize) -> DynResult<()> {
    let count = columns
        .checked_mul(batch_size)
        .ok_or("column count times batch size overflowed")?;
    if count > MYSQL_MAX_PARAMETERS {
        return Err(format!(
            "{columns} columns x {batch_size} rows = {count} parameters, exceeding MySQL limit {MYSQL_MAX_PARAMETERS}"
        )
        .into());
    }
    Ok(())
}

fn build_insert_sql(target: &Target, columns: &[String], rows: usize) -> String {
    let quoted_columns = columns
        .iter()
        .map(|column| format!("`{column}`"))
        .collect::<Vec<_>>()
        .join(",");
    let row = format!("({})", vec!["?"; columns.len()].join(","));
    format!(
        "INSERT INTO {} ({quoted_columns}) VALUES {}",
        quoted_target(target),
        vec![row; rows].join(",")
    )
}

fn append_record_values(record: &csv::ByteRecord, output: &mut Vec<Value>) {
    output.extend(record.iter().map(|field| {
        if field == br"\N" {
            Value::NULL
        } else {
            Value::Bytes(field.to_vec())
        }
    }));
}

fn execute_batch(conn: &mut Conn, statement: &Statement, values: Vec<Value>) -> DynResult<()> {
    let mut transaction = conn.start_transaction(TxOpts::default())?;
    transaction.exec_drop(statement, Params::Positional(values))?;
    transaction.commit()?;
    Ok(())
}

fn load_checkpoint(path: Option<&Path>) -> DynResult<Option<Checkpoint>> {
    let Some(path) = path else {
        return Ok(None);
    };
    if !path.exists() {
        return Ok(None);
    }
    Ok(Some(serde_json::from_reader(BufReader::new(File::open(path)?))?))
}

fn validate_checkpoint(checkpoint: &Checkpoint, manifest: &str, target: &str) -> DynResult<()> {
    if checkpoint.manifest != manifest {
        return Err("checkpoint dataset manifest does not match current input files".into());
    }
    if checkpoint.target != target {
        return Err(format!(
            "checkpoint target {} does not match current target {target}",
            checkpoint.target
        )
        .into());
    }
    Ok(())
}

fn persist_progress(
    path: Option<&Path>,
    manifest: &str,
    target: &str,
    progress: &Progress,
    complete: bool,
) -> DynResult<()> {
    let Some(path) = path else {
        return Ok(());
    };
    let checkpoint = Checkpoint {
        manifest: manifest.to_owned(),
        target: target.to_owned(),
        committed_rows: progress.committed_rows,
        committed_batches: progress.committed_batches,
        complete,
    };
    let mut temporary = path.as_os_str().to_owned();
    temporary.push(".tmp");
    let temporary = PathBuf::from(temporary);
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)?;
    }
    let mut output = File::create(&temporary)?;
    serde_json::to_writer_pretty(&mut output, &checkpoint)?;
    output.write_all(b"\n")?;
    output.sync_all()?;
    fs::rename(temporary, path)?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use flate2::{Compression, write::GzEncoder};
    use tempfile::tempdir;

    #[test]
    fn discovers_gzip_csv_files_in_lexicographic_order() {
        let directory = tempdir().unwrap();
        for name in [
            "bc_bet_records_213.2000.csv.gz",
            "ignored.csv.gz",
            "bc_bet_records_213.1000.csv.gz",
            "bc_bet_records_213.3000.csv.zst",
        ] {
            File::create(directory.path().join(name)).unwrap();
        }
        let files = discover_files(directory.path(), "bc_bet_records_213").unwrap();
        let names = files
            .iter()
            .map(|path| path.file_name().unwrap().to_str().unwrap())
            .collect::<Vec<_>>();
        assert_eq!(
            names,
            ["bc_bet_records_213.1000.csv.gz", "bc_bet_records_213.2000.csv.gz"]
        );
    }

    #[test]
    fn parses_target_and_rejects_unsafe_identifiers() {
        let target = parse_target("test", "bc_bet_records_1m_stream").unwrap();
        assert_eq!(target.database, "test");
        assert_eq!(target.table, "bc_bet_records_1m_stream");
        assert!(parse_target("test", "test.t;DROP TABLE x").is_err());
        assert!(parse_target("test", "a.b.c").is_err());
    }

    #[test]
    fn builds_expected_multi_value_insert() {
        let target = Target {
            database: "test".to_owned(),
            table: "t".to_owned(),
        };
        assert_eq!(
            build_insert_sql(&target, &["a".to_owned(), "b".to_owned()], 2),
            "INSERT INTO `test`.`t` (`a`,`b`) VALUES (?,?),(?,?)"
        );
    }

    #[test]
    fn validates_mysql_parameter_limit() {
        assert!(validate_parameter_count(45, 1_000).is_ok());
        assert!(validate_parameter_count(66, 1_000).is_err());
    }

    #[test]
    fn maps_backslash_n_to_sql_null_without_parsing_decimals() {
        let record = csv::ByteRecord::from(vec!["1.230000", r"\N", "hello"]);
        let mut values = Vec::new();
        append_record_values(&record, &mut values);
        assert_eq!(
            values,
            [
                Value::Bytes(b"1.230000".to_vec()),
                Value::NULL,
                Value::Bytes(b"hello".to_vec())
            ]
        );
    }

    #[test]
    fn gzip_csv_stream_preserves_record_order() {
        let mut encoder = GzEncoder::new(Vec::new(), Compression::fast());
        encoder.write_all(b"3,three\n1,one\n2,two\n").unwrap();
        let compressed = encoder.finish().unwrap();
        let decoder = MultiGzDecoder::new(compressed.as_slice());
        let mut reader = csv::ReaderBuilder::new().has_headers(false).from_reader(decoder);
        let first_fields = reader
            .byte_records()
            .map(|record| record.unwrap()[0].to_vec())
            .collect::<Vec<_>>();
        assert_eq!(first_fields, [b"3", b"1", b"2"]);
    }

    #[test]
    fn checkpoint_round_trip_and_validation() {
        let directory = tempdir().unwrap();
        let path = directory.path().join("checkpoint.json");
        let progress = Progress::new(Duration::from_secs(1), 2_000, 2);
        persist_progress(Some(&path), "a:1\n", "test.t", &progress, false).unwrap();
        let checkpoint = load_checkpoint(Some(&path)).unwrap().unwrap();
        assert_eq!(checkpoint.committed_rows, 2_000);
        assert!(validate_checkpoint(&checkpoint, "a:1\n", "test.t").is_ok());
        assert!(validate_checkpoint(&checkpoint, "b:1\n", "test.t").is_err());
    }
}
