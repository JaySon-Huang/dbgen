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
files use zstd level 1 and contain no header. The 1 million row profile uses
four 250,000-row generator ranges. The 500 million row profile uses one hundred
5-million-row generator ranges. File names emitted by dbgen preserve the
lexicographic row-range order expected by `IMPORT INTO`.

On the current template, the verified 1-million-row sample is approximately
456 MB before compression and 118 MB with zstd level 1. Allow roughly
230-250 GB for the uncompressed 500-million-row stream and 60-70 GB for its
compressed CSV files; actual usage depends on dbgen version and filesystem.

Each output directory contains:

- `bc_bet_records_213-schema.sql`: table DDL;
- `bc_bet_records_213*.csv.zst`: compressed data files;
- `generation.env`: the parameters used for this run.

Validate the generated files before upload. This streams and decompresses the
entire data set without materializing an uncompressed copy:

```sh
examples/tiflash-trim-minmax/validate-csv.sh /data/trim-minmax/1m
```

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
