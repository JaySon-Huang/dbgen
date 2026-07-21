# 500-million-row TiFlash downgrade read-compatibility report

## Status

Read compatibility passed after downgrading the TiFlash instance from the code
logic at `36d92ba355` to `5d56de0` on 2026-07-21.

Both `test.bc_bet_records_500m` and the stream-imported
`test.bc_bet_records_500m_stream` remained readable through TiFlash MPP. Each
table passed a 500-million-row invariant scan and the complete Q01-Q33 suite.
All 133 normalized Q01-Q33 result rows from each table were identical to the
saved TiKV oracle and to each other.

No data, DMFile format, index-version, checksum, or corruption error was found
after the successful downgraded process started.

## Scope

| Item | Value |
| --- | --- |
| Validation date | `2026-07-21` |
| Pre-downgrade code logic | `36d92ba35515dfcdf3d085c0f5239029a0b889ac` |
| Downgraded TiFlash hash | `5d56de051244ac7c893de5ac029f0013098f95dc` |
| Downgraded TiFlash version | `8.5.4-20260409-5d56de0` |
| TiDB endpoint | `10.2.12.79:8020` |
| TiDB version | `8.0.11-TiDB-v8.5.6` |
| TiFlash instance | `10.2.12.81:9522` |
| TiFlash status address | `10.2.12.81:20022` |
| TiFlash metrics address | `10.2.12.81:20522` |
| Tables | `test.bc_bet_records_500m`, `test.bc_bet_records_500m_stream` |

Before the downgrade, both tables had passed correctness and performance tests
with trim min-max selected by the newer code. The downgrade check therefore
validated that the older binary could open and read the existing stable data
and ignore metadata or index files it did not understand.

This validation was deliberately read-only. There were no active `INSERT`,
`UPDATE`, `DELETE`, or `REPLACE` statements during the checks.

## Downgrade startup

The first two downgraded startup attempts failed at
`2026-07-21 10:26:13.435 +08:00` and
`2026-07-21 10:26:32.092 +08:00` with:

```text
DB::Exception: Unknown setting dt_enable_trim_minmax
```

Commit `5d56de0` predates the unified `dt_enable_trim_minmax` setting. The
setting had to be removed from:

```text
/DATA/disk2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml
```

After removing it, the target TiFlash process started successfully:

| Check | Result |
| --- | --- |
| PID | `46722` |
| Process start | `2026-07-21 10:26:46 +08:00` |
| Server start metric | `2026-07-21 10:26:56 +08:00` |
| TCP port `9522` | listening |
| Status port `20022` | listening |
| Metrics port `20522` | listening |

The reported server identity after the successful start was:

```text
tiflash_server_info{
  hash="5d56de051244ac7c893de5ac029f0013098f95dc",
  version="v8.5.4-20260409-5d56de0"
}
```

TiDB's `information_schema.cluster_info` independently reported the same
instance, version, and hash.

The downgraded configuration must not contain `dt_enable_trim_minmax`; adding
it back while running `5d56de0` prevents TiFlash from starting.

## Replica and process state

At `2026-07-21 10:31:26 +08:00`, after all read tests completed, TiDB reported:

| Table | Replica count | Available | Progress |
| --- | ---: | ---: | ---: |
| `bc_bet_records_500m` | 1 | 1 | 1 |
| `bc_bet_records_500m_stream` | 1 | 1 | 1 |

The target process remained alive after both full-table scans and both
Q01-Q33 suites. There were still no active writes to either table.

## Post-start log review

Only log records at or after the successful process start time
`2026-07-21 10:26:46 +08:00` were considered. The two earlier unknown-setting
errors belong to failed startup attempts and were excluded from the running
process health result.

The successful process produced no new `ERROR` or `FATAL` record. Targeted
searches also found no new occurrence of:

- an exception while opening or reading a DMFile;
- an unknown or unsupported file, metadata, or index version;
- checksum failure or data corruption;
- a DMFile read failure.

Normal rough-set descriptions may contain an `unsupported` operator for SQL
expression shapes that fall back conservatively. Those informational records
are expected and are not storage-format compatibility errors.

## Full-table invariant scans

Both aggregates were forced through TiFlash MPP with:

```sql
SET time_zone = '+00:00';
SET SESSION tidb_isolation_read_engines = 'tiflash';
SET SESSION tidb_allow_mpp = 1;
SET SESSION tidb_enforce_mpp = 1;
```

The MPP statistics reported 500,000,000 output rows from each full-table scan.
Both tables returned the same 16 invariant fields:

| Check | `bc_bet_records_500m` | `bc_bet_records_500m_stream` |
| --- | ---: | ---: |
| Total rows | 500,000,000 | 500,000,000 |
| Minimum generated row number | 1 | 1 |
| Maximum generated row number | 500,000,000 | 500,000,000 |
| Sum of generated row numbers | 125,000,000,250,000,000 | 125,000,000,250,000,000 |
| Sentinel rows at `2100-01-01 00:00:00` | 49,748 | 49,748 |
| NULL `settle_time` rows | 0 | 0 |
| Minimum normal `settle_time` | `2026-04-17 00:00:00` | `2026-04-17 00:00:00` |
| Maximum normal `settle_time` | `2026-07-15 23:59:59` | `2026-07-15 23:59:59` |
| `settle_status=1` | 49,748 | 49,748 |
| `settle_status=2` | 499,450,747 | 499,450,747 |
| `settle_status=3` | 499,505 | 499,505 |
| Other settle statuses | 0 | 0 |
| `category_id=5` | 124,999,205 | 124,999,205 |
| Rows whose `site_code` is not `213` | 0 | 0 |
| Rows whose `currency` is not `CNY` | 0 | 0 |
| Rows whose `settle_date` differs from `DATE(settle_time)` | 0 | 0 |

These values match the pre-downgrade correctness results exactly.

## Complete Q01-Q33 validation

The complete `tiflash-correctness.sql` suite was run through the downgraded
TiFlash after replacing only `bc_bet_records_1m` with the table under test.
The suite covers bounded and one-sided temporal predicates, equality and `IN`,
outside-range and unsupported-shape fallback, mixed logical expressions,
`GROUP BY`, and deterministic TopN/`LIMIT` output.

The saved TiKV transcript `tiflash-correctness-tikv_result.sql` was used as the
SQL-semantics oracle.

| Result | `bc_bet_records_500m` | `bc_bet_records_500m_stream` |
| --- | ---: | ---: |
| Query cases present | 33 | 33 |
| Normalized result rows | 133 | 133 |
| Differences from TiKV oracle | 0 | 0 |
| Differences between the two tables | 0 | 0 |
| Command exit code | 0 | 0 |

The 133 rows consist of:

- one count/checksum row from each of Q01-Q31;
- two grouped rows from Q32;
- the complete deterministic 100-row Q33 result.

Both suites completed successfully in approximately eight seconds. No query
fell back to TiKV because the sessions enforced TiFlash MPP.

## Conclusion and limits

The downgrade read-compatibility gate passed:

1. the `5d56de0` process starts after removing its unknown setting;
2. TiDB sees the downgraded TiFlash instance and both replicas as available;
3. both stable-data layouts can be scanned completely;
4. both data sets retain their exact import invariants;
5. all Q01-Q33 results match the TiKV oracle exactly;
6. no post-start storage-format or read error was logged;
7. the process and replicas remain healthy after the tests.

This report validates read compatibility only. It does not validate writes,
flushes, stable DMFile rewrites, merge/compaction, schema changes, replica
rebuilds, or upgrading back to the newer binary after the downgraded process
has modified storage. Those operations require a separate compatibility test
before being considered safe.
