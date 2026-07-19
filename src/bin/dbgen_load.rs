use clap::Parser;
use crossbeam_channel::{Receiver, SendTimeoutError, Sender, bounded};
use flate2::read::MultiGzDecoder;
use mysql::{Conn, OptsBuilder, Params, Statement, TxOpts, Value, prelude::Queryable};
use std::{
    error::Error,
    ffi::OsStr,
    fs::{self, File},
    io::BufReader,
    path::{Path, PathBuf},
    sync::{
        Arc, Mutex,
        atomic::{AtomicBool, Ordering},
    },
    thread,
    time::{Duration, Instant},
};

#[cfg(test)]
use std::io::Write;

type DynResult<T> = Result<T, Box<dyn Error>>;

const DEFAULT_BATCH_SIZE: usize = 1_000;
const DEFAULT_CONCURRENCY: usize = 1;
const MAX_CONCURRENCY: usize = 256;
const MYSQL_MAX_PARAMETERS: usize = 65_535;

#[derive(Debug, Parser)]
#[command(about = "Stream dbgen gzip CSV files into TiDB with configurable write concurrency")]
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

    /// Number of concurrent TiDB writer connections.
    #[arg(long, default_value_t = DEFAULT_CONCURRENCY)]
    concurrency: usize,

    /// Maximum queued batches. Defaults to twice --concurrency.
    #[arg(long)]
    queue_capacity: Option<usize>,

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

#[derive(Debug, Clone)]
struct DatabaseOptions {
    host: String,
    port: u16,
    user: String,
    password: String,
    database: String,
}

impl DatabaseOptions {
    fn connect(&self) -> mysql::Result<Conn> {
        let opts = OptsBuilder::default()
            .ip_or_hostname(Some(self.host.clone()))
            .tcp_port(self.port)
            .user(Some(self.user.clone()))
            .pass(Some(self.password.clone()))
            .db_name(Some(self.database.clone()));
        Conn::new(opts)
    }
}

#[derive(Debug, Clone)]
struct Target {
    database: String,
    table: String,
}

#[derive(Debug)]
struct Batch {
    sequence: u64,
    source_file: PathBuf,
    records: Vec<csv::ByteRecord>,
}

impl Batch {
    fn row_count(&self) -> usize {
        self.records.len()
    }
}

#[derive(Debug, Default, PartialEq, Eq)]
struct SourceStats {
    rows: u64,
    batches: u64,
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
    fn new(report_every: Duration) -> Self {
        let now = Instant::now();
        Self {
            started_at: now,
            last_report_at: now,
            report_every,
            committed_rows: 0,
            committed_batches: 0,
        }
    }

    fn committed(&mut self, batch: &Batch) {
        self.committed_rows += batch.row_count() as u64;
        self.committed_batches += 1;
        let now = Instant::now();
        if now.duration_since(self.last_report_at) >= self.report_every {
            let elapsed = now.duration_since(self.started_at).as_secs_f64().max(0.001);
            eprintln!(
                "progress: rows={} batches={} rate={:.1} rows/s last_batch={} file={}",
                self.committed_rows,
                self.committed_batches,
                self.committed_rows as f64 / elapsed,
                batch.sequence,
                batch.source_file.display()
            );
            self.last_report_at = now;
        }
    }
}

struct MysqlBatchExecutor {
    conn: Conn,
    full_statement: Statement,
    target: Target,
    columns: Arc<Vec<String>>,
    batch_size: usize,
}

impl MysqlBatchExecutor {
    fn new(
        database: &DatabaseOptions,
        target: Target,
        columns: Arc<Vec<String>>,
        batch_size: usize,
    ) -> mysql::Result<Self> {
        let mut conn = database.connect()?;
        let full_statement = conn.prep(build_insert_sql(&target, &columns, batch_size))?;
        Ok(Self {
            conn,
            full_statement,
            target,
            columns,
            batch_size,
        })
    }

    fn execute(&mut self, batch: &Batch) -> mysql::Result<()> {
        let mut values = Vec::with_capacity(batch.row_count() * self.columns.len());
        for record in &batch.records {
            append_record_values(record, &mut values);
        }

        if batch.row_count() == self.batch_size {
            execute_batch(&mut self.conn, &self.full_statement, values)
        } else {
            let statement = self
                .conn
                .prep(build_insert_sql(&self.target, &self.columns, batch.row_count()))?;
            execute_batch(&mut self.conn, &statement, values)
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
    validate_args(&args)?;
    let queue_capacity = args.queue_capacity.unwrap_or(args.concurrency.saturating_mul(2));
    if queue_capacity == 0 {
        return Err("--queue-capacity must be greater than zero".into());
    }

    let files = discover_files(&args.input_dir, &args.file_prefix)?;
    let target = parse_target(&args.database, &args.table)?;
    let target_name = format!("{}.{}", target.database, target.table);
    let database = DatabaseOptions {
        host: args.host,
        port: args.port,
        user: args.user,
        password: args
            .password
            .or_else(|| std::env::var("TIDB_PASSWORD").ok())
            .unwrap_or_default(),
        database: target.database.clone(),
    };

    let mut validation_conn = database.connect()?;
    let columns = load_target_columns(&mut validation_conn, &target)?;
    if columns.is_empty() {
        return Err(format!("target table {target_name} does not exist or has no writable columns").into());
    }
    validate_parameter_count(columns.len(), args.batch_size)?;

    let existing_rows = target_row_count(&mut validation_conn, &target)?;
    if existing_rows != 0 && !args.allow_nonempty {
        return Err(format!(
            "target table {target_name} is not empty ({existing_rows} rows); clear it before a full retry, or use --allow-nonempty only if intentional"
        )
        .into());
    }
    drop(validation_conn);

    eprintln!(
        "loading: files={} target={} columns={} batch_size={} concurrency={} queue_capacity={} dry_run={}",
        files.len(),
        target_name,
        columns.len(),
        args.batch_size,
        args.concurrency,
        queue_capacity,
        args.dry_run
    );

    let progress = Arc::new(Mutex::new(Progress::new(Duration::from_secs(args.report_every))));
    let started_at = Instant::now();
    let source_stats = if args.dry_run {
        produce_batches(&files, columns.len(), args.batch_size, |batch| {
            progress.lock().unwrap().committed(&batch);
            Ok(())
        })?
    } else {
        run_parallel_load(
            &files,
            database,
            target,
            Arc::new(columns),
            args.batch_size,
            args.concurrency,
            queue_capacity,
            Arc::clone(&progress),
        )?
    };

    let progress = progress.lock().unwrap();
    if progress.committed_rows != source_stats.rows || progress.committed_batches != source_stats.batches {
        return Err(format!(
            "internal count mismatch: source rows/batches={}/{}, committed={}/{}",
            source_stats.rows, source_stats.batches, progress.committed_rows, progress.committed_batches
        )
        .into());
    }
    let elapsed = started_at.elapsed().as_secs_f64().max(0.001);
    eprintln!(
        "done: rows={} batches={} elapsed={elapsed:.1}s average={:.1} rows/s concurrency={} dry_run={}",
        progress.committed_rows,
        progress.committed_batches,
        progress.committed_rows as f64 / elapsed,
        args.concurrency,
        args.dry_run
    );
    Ok(())
}

fn validate_args(args: &Args) -> DynResult<()> {
    if args.batch_size == 0 {
        return Err("--batch-size must be greater than zero".into());
    }
    if !(1..=MAX_CONCURRENCY).contains(&args.concurrency) {
        return Err(format!("--concurrency must be between 1 and {MAX_CONCURRENCY}").into());
    }
    if args.report_every == 0 {
        return Err("--report-every must be greater than zero".into());
    }
    Ok(())
}

#[allow(clippy::too_many_arguments)]
fn run_parallel_load(
    files: &[PathBuf],
    database: DatabaseOptions,
    target: Target,
    columns: Arc<Vec<String>>,
    batch_size: usize,
    concurrency: usize,
    queue_capacity: usize,
    progress: Arc<Mutex<Progress>>,
) -> DynResult<SourceStats> {
    let (sender, receiver) = bounded(queue_capacity);
    let canceled = Arc::new(AtomicBool::new(false));
    let mut workers = Vec::with_capacity(concurrency);

    for worker_id in 0..concurrency {
        let receiver = receiver.clone();
        let canceled = Arc::clone(&canceled);
        let progress = Arc::clone(&progress);
        let database = database.clone();
        let target = target.clone();
        let columns = Arc::clone(&columns);
        workers.push(thread::spawn(move || {
            let mut executor = MysqlBatchExecutor::new(&database, target, columns, batch_size).map_err(|error| {
                canceled.store(true, Ordering::Release);
                format!("worker {worker_id} connection/prepare failed: {error}")
            })?;
            consume_batches(worker_id, &receiver, &canceled, &progress, |batch| {
                executor.execute(batch).map_err(|error| error.to_string())
            })
        }));
    }
    drop(receiver);

    let produce_result = produce_batches(files, columns.len(), batch_size, |batch| {
        send_batch(&sender, batch, &canceled)
    });
    drop(sender);
    if produce_result.is_err() {
        canceled.store(true, Ordering::Release);
    }

    let mut worker_error = None;
    for worker in workers {
        match worker.join() {
            Ok(Ok(())) => {}
            Ok(Err(error)) => {
                worker_error.get_or_insert(error);
            }
            Err(_) => {
                worker_error.get_or_insert_with(|| "writer worker panicked".to_owned());
            }
        };
    }
    if let Some(error) = worker_error {
        return Err(format!(
            "{error}; target may be partially loaded, clear {}.{} and retry the complete dataset",
            database.database, target.table
        )
        .into());
    }
    produce_result
}

fn consume_batches<F>(
    worker_id: usize,
    receiver: &Receiver<Batch>,
    canceled: &AtomicBool,
    progress: &Mutex<Progress>,
    mut execute: F,
) -> Result<(), String>
where
    F: FnMut(&Batch) -> Result<(), String>,
{
    loop {
        if canceled.load(Ordering::Acquire) {
            return Ok(());
        }
        let batch = match receiver.recv_timeout(Duration::from_millis(100)) {
            Ok(batch) => batch,
            Err(crossbeam_channel::RecvTimeoutError::Timeout) => continue,
            Err(crossbeam_channel::RecvTimeoutError::Disconnected) => return Ok(()),
        };
        if let Err(error) = execute(&batch) {
            canceled.store(true, Ordering::Release);
            return Err(format!(
                "worker {worker_id} failed on batch {}: {error}",
                batch.sequence
            ));
        }
        progress.lock().unwrap().committed(&batch);
    }
}

fn send_batch(sender: &Sender<Batch>, mut batch: Batch, canceled: &AtomicBool) -> DynResult<()> {
    loop {
        if canceled.load(Ordering::Acquire) {
            return Err("writer canceled after a worker failure".into());
        }
        match sender.send_timeout(batch, Duration::from_millis(100)) {
            Ok(()) => return Ok(()),
            Err(SendTimeoutError::Timeout(returned)) => batch = returned,
            Err(SendTimeoutError::Disconnected(_)) => return Err("all writer workers disconnected".into()),
        }
    }
}

fn produce_batches<F>(files: &[PathBuf], column_count: usize, batch_size: usize, mut emit: F) -> DynResult<SourceStats>
where
    F: FnMut(Batch) -> DynResult<()>,
{
    let mut stats = SourceStats::default();
    let mut pending = Vec::with_capacity(batch_size);
    let mut last_file = files[0].clone();

    for file in files {
        last_file.clone_from(file);
        let input = BufReader::new(File::open(file)?);
        let decoder = MultiGzDecoder::new(input);
        let mut reader = csv::ReaderBuilder::new().has_headers(false).from_reader(decoder);

        for record in reader.byte_records() {
            let record = record.map_err(|error| format!("read {}: {error}", file.display()))?;
            stats.rows += 1;
            if record.len() != column_count {
                return Err(format!(
                    "{} row {} has {} fields, target has {} columns",
                    file.display(),
                    stats.rows,
                    record.len(),
                    column_count
                )
                .into());
            }
            pending.push(record);
            if pending.len() == batch_size {
                emit(Batch {
                    sequence: stats.batches,
                    source_file: file.clone(),
                    records: std::mem::replace(&mut pending, Vec::with_capacity(batch_size)),
                })?;
                stats.batches += 1;
            }
        }
    }

    if !pending.is_empty() {
        emit(Batch {
            sequence: stats.batches,
            source_file: last_file,
            records: pending,
        })?;
        stats.batches += 1;
    }
    Ok(stats)
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

fn execute_batch(conn: &mut Conn, statement: &Statement, values: Vec<Value>) -> mysql::Result<()> {
    let mut transaction = conn.start_transaction(TxOpts::default())?;
    transaction.exec_drop(statement, Params::Positional(values))?;
    transaction.commit()
}

#[cfg(test)]
mod tests {
    use super::*;
    use flate2::{Compression, write::GzEncoder};
    use std::collections::BTreeSet;
    use tempfile::tempdir;

    fn write_gzip(path: &Path, content: &[u8]) {
        let mut encoder = GzEncoder::new(File::create(path).unwrap(), Compression::fast());
        encoder.write_all(content).unwrap();
        encoder.finish().unwrap();
    }

    fn test_batch(sequence: u64) -> Batch {
        Batch {
            sequence,
            source_file: PathBuf::from("test.csv.gz"),
            records: vec![csv::ByteRecord::from(vec![sequence.to_string()])],
        }
    }

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
    fn producer_preserves_file_and_row_order_when_batching() {
        let directory = tempdir().unwrap();
        write_gzip(&directory.path().join("data.2000.csv.gz"), b"5,e\n6,f\n");
        write_gzip(&directory.path().join("data.1000.csv.gz"), b"1,a\n2,b\n3,c\n4,d\n");
        let files = discover_files(directory.path(), "data").unwrap();
        let mut output = Vec::new();
        let stats = produce_batches(&files, 2, 2, |batch| {
            output.push((
                batch.sequence,
                batch
                    .records
                    .iter()
                    .map(|record| record[0].to_vec())
                    .collect::<Vec<_>>(),
            ));
            Ok(())
        })
        .unwrap();
        assert_eq!(stats, SourceStats { rows: 6, batches: 3 });
        assert_eq!(
            output,
            [
                (0, vec![b"1".to_vec(), b"2".to_vec()]),
                (1, vec![b"3".to_vec(), b"4".to_vec()]),
                (2, vec![b"5".to_vec(), b"6".to_vec()])
            ]
        );
    }

    #[test]
    fn multiple_consumers_process_every_batch_once() {
        let (sender, receiver) = bounded(4);
        let canceled = Arc::new(AtomicBool::new(false));
        let progress = Arc::new(Mutex::new(Progress::new(Duration::from_secs(60))));
        let completed = Arc::new(Mutex::new(BTreeSet::new()));
        let mut workers = Vec::new();
        for worker_id in 0..4 {
            let receiver = receiver.clone();
            let canceled = Arc::clone(&canceled);
            let progress = Arc::clone(&progress);
            let completed = Arc::clone(&completed);
            workers.push(thread::spawn(move || {
                consume_batches(worker_id, &receiver, &canceled, &progress, |batch| {
                    completed.lock().unwrap().insert(batch.sequence);
                    Ok(())
                })
            }));
        }
        drop(receiver);
        for sequence in 0..40 {
            send_batch(&sender, test_batch(sequence), &canceled).unwrap();
        }
        drop(sender);
        for worker in workers {
            worker.join().unwrap().unwrap();
        }
        assert_eq!(*completed.lock().unwrap(), (0..40).collect());
        assert_eq!(progress.lock().unwrap().committed_batches, 40);
    }

    #[test]
    fn consumer_failure_cancels_other_work() {
        let (sender, receiver) = bounded(1);
        let canceled = AtomicBool::new(false);
        let progress = Mutex::new(Progress::new(Duration::from_secs(60)));
        sender.send(test_batch(7)).unwrap();
        drop(sender);
        let error = consume_batches(3, &receiver, &canceled, &progress, |_| Err("injected".to_owned())).unwrap_err();
        assert!(error.contains("worker 3 failed on batch 7"));
        assert!(canceled.load(Ordering::Acquire));
        assert_eq!(progress.lock().unwrap().committed_batches, 0);
    }

    #[test]
    fn send_stops_after_cancellation() {
        let (sender, _receiver) = bounded(1);
        let canceled = AtomicBool::new(true);
        assert!(send_batch(&sender, test_batch(0), &canceled).is_err());
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
}
