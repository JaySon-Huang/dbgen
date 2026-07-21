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
  --batch-size 1000 --concurrency 8
```

Use `--dry-run` first to decompress and validate every CSV record and the target
schema without inserting rows. By default, a real load refuses to start when
the target table is non-empty. Concurrent workers may commit batches out of
order; the generated primary key preserves the source row order for queries
using `ORDER BY id`. If any worker fails, clear the partially loaded table and
restart the complete data set.

With dbgen v0.8.0 and the checked-in seed, the verified 1-million-row profile
contains 1,000,000 rows, 45 fields per row, 102 sentinel rows, and 3,053 rows
matching the benchmark predicate.

## Import and verify

Run the generated schema SQL, upload or copy the CSV files to a location TiDB
can access, and adapt `import-into.sql` to that location. After import, use
`verify.sql` to check the row count, sentinel distribution, time range, row ID
shards, and the number of rows matching the benchmark predicate.

Enable `dt_enable_trim_minmax` before TiFlash creates stable DMFiles. To compare
ordinary and trim min-max fairly, stop writes and benchmark the same imported
table while toggling this setting only. `benchmark-query.sql` contains the
target query.

For the imported `test.bc_bet_records_1m` sample, use the executable SQL suite:

1. `tiflash-precheck.sql`: verify replica availability, dataset identity, and
   that the target plan uses TiFlash MPP;
2. `tiflash-correctness.sql`: run the same query set through TiKV, TiFlash
   ordinary min-max, and TiFlash trim min-max, then compare exact
   counts/checksums and a deterministic TopN result set;
3. `tiflash-benchmark.sql`: collect `EXPLAIN ANALYZE` for multiple time-window
   selectivities, the outside-range fallback, and the production-shaped query.

Example invocation:

```sh
mycli -h 10.2.12.79 -P 8020 -u root -D test --noninteractive \
  --batch examples/tiflash-trim-minmax/tiflash-precheck.sql
```

`dt_enable_trim_minmax` is a TiFlash `[profiles.default]` setting rather than a
TiDB session variable. It controls both trim-index generation and use. Create
or rewrite the stable DMFiles while the setting is `true`, then stop all writes
to the table before switching it to `false` for the ordinary-min-max read
baseline. If the setting was `false` while all stable DMFiles were created,
turning it on later cannot test trim reads until those DMFiles are recreated or
naturally rewritten.

## Run the correctness comparison

The target cluster has one TiFlash instance on `k81`:

| Instance | Configuration | Log |
| --- | --- | --- |
| `10.2.12.81:9522` | `/DATA/disk2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml` | `/DATA/disk2/jaysonhuang/clusters/tiflash-5022/log/tiflash.log` |

First run the SQL through TiKV to establish the SQL-semantics oracle. The SQL
uses `@correctness_engine`, so the same file is used without editing hints:

```sh
mycli -h 10.2.12.79 -P 8020 -u root -D test \
  --init-command "SET @correctness_engine='tikv'" \
  --noninteractive --format tsv \
  --batch examples/tiflash-trim-minmax/tiflash-correctness.sql \
  > correctness-tikv.tsv
```

Set the single trim switch to `false` for the ordinary min-max TiFlash round:

```sh
ssh k81 "sed -i -E \
  's/^(dt_enable_trim_minmax[[:space:]]*=[[:space:]]*)(true|false)$/\1false/' \
  /DATA/disk2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml"
```

Wait for the new reload record, then run the ordinary baseline:

```sh
ssh k81 "rg 'reload delta tree.*dt_enable_trim_minmax.*new: false' \
  /DATA/disk2/jaysonhuang/clusters/tiflash-5022/log/tiflash.log | tail -n 2"

mycli -h 10.2.12.79 -P 8020 -u root -D test \
  --init-command "SET @correctness_engine='tiflash'" \
  --noninteractive --format tsv \
  --batch examples/tiflash-trim-minmax/tiflash-correctness.sql \
  > correctness-tiflash-ordinary.tsv
```

Enable trim again, wait for reload, and run the trim candidate without writing
to or rebuilding the table between rounds:

```sh
ssh k81 "sed -i -E \
  's/^(dt_enable_trim_minmax[[:space:]]*=[[:space:]]*)(true|false)$/\1true/' \
  /DATA/disk2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml"

ssh k81 "rg 'reload delta tree.*dt_enable_trim_minmax.*new: true' \
  /DATA/disk2/jaysonhuang/clusters/tiflash-5022/log/tiflash.log | tail -n 2"

mycli -h 10.2.12.79 -P 8020 -u root -D test \
  --init-command "SET @correctness_engine='tiflash'" \
  --noninteractive --format tsv \
  --batch examples/tiflash-trim-minmax/tiflash-correctness.sql \
  > correctness-tiflash-trim.tsv
```

Inspect the reload timestamps rather than accepting an older matching line.
All query rows must be identical in the three outputs:

```sh
diff -u correctness-tikv.tsv correctness-tiflash-ordinary.tsv
diff -u correctness-tikv.tsv correctness-tiflash-trim.tsv
```

The SQL covers the production-shaped bounded ranges plus eligible equality,
IN, all four one-sided comparisons, explicit inclusive/exclusive AND ranges,
the exclusive `2099-12-01` upper edge, outside-range fallback, unsupported and
NULL-sensitive expression shapes, mixed logical trees, GROUP BY, and a
deterministic TopN/LIMIT result set. Pack-level low/high/NULL/delete-mark
matrices, fractional temporal types, and malformed index payloads remain unit-
test responsibilities and are intentionally not recreated in this end-to-end
dataset.

To prove that the intended trim and fallback paths were exercised, snapshot
the single TiFlash node's counters before and after the trim round:

```sh
ssh k81 "curl -fsS http://127.0.0.1:20522/metrics | \
  rg '^tiflash_storage_trim_minmax_(select|rough_check|correction)_.*'"
```

The trim round should increase `select_count{result="used"}` and
`select_count{result="fallback_predicate_outside_range"}`. The one-sided and
bounded-range cases should also exercise `correction_pack_count` for
`none_to_some` and/or `all_to_some`. These counters prove path coverage; the
three-way result diff remains the correctness gate.

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

For each printed TSO, collect the final task statistics from the TiFlash
instance. Replace the example value below with the TSO for the query:

```sh
TSO=467698350143045633

ssh k81 "rg 'MPPTaskStatistics\\.cpp' \
  /DATA/disk2/jaysonhuang/clusters/tiflash-5022/log/tiflash.log \
  | rg '$TSO' \
  | rg '\[INFO\]'"
```

The DEBUG record describes the `INITIALIZING` state. The INFO record contains
the final `FINISHED` statistics, including executor row counts, DMFile scanned
and skipped rows, late-materialization counters, rough-set pack-filter counts,
read time, memory, and RU. A query can still have multiple MPP tasks on the
instance, so sum additive counters across all matching INFO records. Keep
per-task elapsed time separate because the tasks execute in parallel.

The current log payload exposes the rough-set expression and pack-filter
counters, but does not contain an explicit `trim_minmax_used` field. Use the
trim-minmax Prometheus counters described above to prove index selection and
fallback; use the TSO-correlated logs for per-query scan behavior.
