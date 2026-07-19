# TiFlash trim min-max benchmark data

This example generates the `bc_bet_records_213` data set used to benchmark
trim min-max filtering for date and time columns.

## Data model

- All non-sentinel `settle_time` values are monotonically mapped from `rownum`
  over `[2026-04-17 00:00:00, 2026-07-15 23:59:59]` in UTC.
- Every row independently becomes a sentinel row with probability `0.0001`.
  Sentinel rows use `settle_time = 2100-01-01 00:00:00` and
  `settle_status = 1`.
- Normal rows are almost all `settle_status = 2`; 0.1% are status 3.
- `site_code = '213'` and `currency = 'CNY'` on every row.
- `category_id = 5` on 25% of rows. Other rows use categories 1, 2, 3, 4,
  6, 7, and 8.
- The table keeps `PRIMARY KEY ... NONCLUSTERED`, `SHARD_ROW_ID_BITS=4`, and
  `PRE_SPLIT_REGIONS=3` to match the target schema.

With 8192 rows per pack and independent sentinel probability `1/10000`, the
expected fraction of packs containing at least one sentinel is:

```text
1 - (1 - 0.0001)^8192 = 55.92%
```

## Generate data

Build `dbgen` automatically if no release binary or `DBGEN_BIN` is available,
then generate the 1 million row sample:

```sh
examples/tiflash-trim-minmax/generate-1m.sh
```

Generate the 500 million row data set:

```sh
examples/tiflash-trim-minmax/generate-500m.sh
```

Pass a different output directory as the first argument:

```sh
examples/tiflash-trim-minmax/generate-1m.sh /data/trim-minmax/1m
examples/tiflash-trim-minmax/generate-500m.sh /data/trim-minmax/500m
```

Useful environment overrides:

```sh
DBGEN_BIN=/path/to/dbgen JOBS=8 \
  examples/tiflash-trim-minmax/generate-1m.sh /data/trim-minmax/1m

JOBS=32 SENTINEL_PROBABILITY=0.0001 \
  examples/tiflash-trim-minmax/generate-500m.sh /data/trim-minmax/500m
```

The scripts refuse to write into a non-empty output directory. Generated CSV
files use gzip level 1 and contain no header. The 1 million row profile uses
four 250,000-row generator ranges. The 500 million row profile uses one hundred
5-million-row generator ranges. File names emitted by dbgen preserve the
lexicographic row-range order expected by `IMPORT INTO`.

On the current template, the verified 1-million-row sample is approximately
456 MiB before compression and 159 MiB with gzip level 1. Allow roughly
230-250 GB for the uncompressed 500-million-row stream and remeasure available
space for gzip output before a full run; actual usage depends on dbgen version
and filesystem.

Each output directory contains:

- `bc_bet_records_213-schema.sql`: table DDL;
- `bc_bet_records_213*.csv.gz`: compressed data files;
- `generation.env`: the parameters used for this run.

Validate the generated files before upload. This streams and decompresses the
entire data set without materializing an uncompressed copy:

```sh
examples/tiflash-trim-minmax/validate-csv.sh /data/trim-minmax/1m
```

## Stream into TiDB in generation order

Build the Rust loader and insert the gzip CSV records sequentially. The loader
sorts dbgen file names lexicographically, preserves row order within each file,
and commits one multi-value statement per 1,000 rows:

```sh
cargo build --release --features tidb-loader --bin dbgen-load

target/release/dbgen-load \
  --input-dir /data/trim-minmax/1m \
  --host 10.2.12.79 --port 8020 --user root \
  --database test --table bc_bet_records_1m_stream \
  --batch-size 1000 \
  --checkpoint /tmp/dbgen-load-bc-bet-records-1m-stream.json
```

Use `--dry-run` first to decompress and validate every CSV record and the target
schema without inserting rows. By default, a real load refuses to start when
the target table is non-empty. A checkpoint is updated only after a transaction
commits and may be used to resume an interrupted load.

With dbgen v0.8.0 and the checked-in seed, the verified 1-million-row profile
contains 1,000,000 rows, 45 fields per row, 102 sentinel rows, and 3,053 rows
matching the benchmark predicate.

## Import and verify

Run the generated schema SQL, upload or copy the CSV files to a location TiDB
can access, and adapt `import-into.sql` to that location. After import, use
`verify.sql` to check the row count, sentinel distribution, time range, row ID
shards, and the number of rows matching the benchmark predicate.

Enable trim min-max writing before TiFlash creates stable DMFiles. To compare
ordinary and trim min-max fairly, benchmark the same imported table while only
toggling trim min-max reading. `benchmark-query.sql` contains the target query.

For the imported `test.bc_bet_records_1m` sample, use the executable SQL suite:

1. `tiflash-precheck.sql`: verify replica availability, dataset identity, and
   that the target plan uses TiFlash MPP;
2. `tiflash-correctness.sql`: compare exact counts/checksums with trim reads off
   and on, including same-column inside/outside mixed predicates;
3. `tiflash-benchmark.sql`: collect `EXPLAIN ANALYZE` for multiple time-window
   selectivities, the outside-range fallback, and the production-shaped query.

Example invocation:

```sh
mycli -h 10.2.12.79 -P 8020 -u root -D test --noninteractive \
  --batch examples/tiflash-trim-minmax/tiflash-precheck.sql
```

The trim switches are TiFlash `[profiles.default]` settings rather than TiDB
session variables. Use the same `dt_enable_trim_minmax_write=true` data files
and change only `dt_enable_trim_minmax_read` between the primary A/B rounds.
If trim writing was disabled while the replica/DMFiles were created, enabling
trim reading alone cannot test the optimization; recreate or rewrite those
DMFiles after enabling trim writing.

## Switch trim min-max reading

Both TiFlash instances run on `k81`. Their configuration and log files are:

| Instance | Configuration | Log |
| --- | --- | --- |
| `10.2.12.81:9522` | `/data2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml` | `/data2/jaysonhuang/clusters/tiflash-5022/log/tiflash.log` |
| `10.2.12.81:9523` | `/data2/jaysonhuang/clusters/tiflash-5023/conf/tiflash.toml` | `/data2/jaysonhuang/clusters/tiflash-5023/log/tiflash.log` |

Keep `dt_enable_trim_minmax_write=true` in both A/B rounds. Set trim reading to
`false` for the ordinary min-max baseline:

```sh
ssh k81 "sed -i -E \
  's/^(dt_enable_trim_minmax_read[[:space:]]*=[[:space:]]*)(true|false)$/\1false/' \
  /data2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml \
  /data2/jaysonhuang/clusters/tiflash-5023/conf/tiflash.toml"
```

Set it to `true` for the trim min-max round:

```sh
ssh k81 "sed -i -E \
  's/^(dt_enable_trim_minmax_read[[:space:]]*=[[:space:]]*)(true|false)$/\1true/' \
  /data2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml \
  /data2/jaysonhuang/clusters/tiflash-5023/conf/tiflash.toml"
```

Verify the persisted values:

```sh
ssh k81 "rg -n \
  '^[[:space:]]*dt_enable_trim_minmax_read[[:space:]]*=' \
  /data2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml \
  /data2/jaysonhuang/clusters/tiflash-5023/conf/tiflash.toml"
```

TiFlash reloads these settings without a restart. Do not start a benchmark
until both logs contain a new `reload delta tree` record with the requested
value. For example, after enabling trim reads:

```sh
ssh k81 "rg -n \
  'reload delta tree.*dt_enable_trim_minmax_read.*new: true' \
  /data2/jaysonhuang/clusters/tiflash-5022/log/tiflash.log \
  /data2/jaysonhuang/clusters/tiflash-5023/log/tiflash.log | tail -n 4"
```

Inspect the timestamps rather than accepting an older matching line. The two
instances may reload a few seconds apart. Repeat the command with `new: false`
when preparing the baseline round.

## Correlate benchmark queries with TiFlash logs

Each query in `tiflash-benchmark.sql` now follows this pattern:

```sql
BEGIN;
SELECT 'P02_27h' AS query_name, @@tidb_current_ts AS query_tso;
EXPLAIN ANALYZE SELECT ...;
ROLLBACK;
```

One query per transaction gives every P01-P06 execution a distinct TSO. The
printed `query_tso` is recorded as both `query_tso` and `start_ts` in
`MPPTaskStatistics.cpp` logs.

Capture the SQL output for one benchmark round:

```sh
mycli -h 10.2.12.79 -P 8020 -u root -D test \
  --noninteractive --format tsv \
  --batch examples/tiflash-trim-minmax/tiflash-benchmark.sql \
  > benchmark-trim-on.tsv
```

For each printed TSO, collect the final task statistics from both TiFlash
instances. Replace the example value below with the TSO for the query:

```sh
TSO=467698350143045633

ssh k81 "rg 'MPPTaskStatistics\\.cpp' \
  /data2/jaysonhuang/clusters/tiflash-5022/log/tiflash.log \
  /data2/jaysonhuang/clusters/tiflash-5023/log/tiflash.log \
  | rg '$TSO' \
  | rg '\[INFO\]'"
```

The DEBUG record describes the `INITIALIZING` state. The INFO record contains
the final `FINISHED` statistics, including executor row counts, DMFile scanned
and skipped rows, late-materialization counters, rough-set pack-filter counts,
read time, memory, and RU. A query can have tasks on both instances, so sum
additive counters across all matching INFO records. Keep per-task elapsed time
separate because the tasks execute in parallel.

The current log payload exposes the rough-set expression and pack-filter
counters, but does not contain an explicit `trim_minmax_used` field. It can
demonstrate changes in pruning behavior, but cannot by itself prove which
min-max representation was selected.
