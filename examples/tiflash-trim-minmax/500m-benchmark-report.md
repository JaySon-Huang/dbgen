# 500-million-row trim min-max benchmark report

## Status

The benchmark was executed on 2026-07-21 against both
`test.bc_bet_records_500m` and the stream-imported
`test.bc_bet_records_500m_stream`. For each table, the same table and TiFlash
replica were used for both configurations. No writes or DMFile rewrites
occurred between rounds.

For the five-query eligible workload P01-P04 and P06, enabling trim min-max
reduced median query latency by 11.9%-50.7%. The complete P01-P06 suite's
median client wall time decreased from 2,125 ms to 1,613 ms, a 24.1%
reduction, or 1.32x speedup. The P05 outside-range control had no scan
reduction and no performance benefit, as expected.

The stream-imported table showed the same trend. Its complete-suite median
decreased from 2,066 ms to 1,553 ms, a 24.9% reduction, or 1.33x speedup.

## Build identity note

The deployed binary contains the code logic corresponding to local TiFlash
commit:

```text
36d92ba35515dfcdf3d085c0f5239029a0b889ac
```

Due to a known compilation metadata problem, `tiflash_server_info` reports
the stale build identity below instead of the code commit actually running:

```text
version="v8.5.4-20260713-4b2815a-5-g7d70c1ce4d"
hash="7d70c1ce4d09cc018080a638e6a450018ff0e388"
```

The results in this report should therefore be associated with the
`36d92ba355` code logic, not with the stale hash exposed by the build metadata.

## Environment

| Item | Value |
| --- | --- |
| Date | `2026-07-21` |
| TiDB endpoint | `10.2.12.79:8020` |
| TiDB version | `8.0.11-TiDB-v8.5.6` |
| Database and tables | `test.bc_bet_records_500m`, `test.bc_bet_records_500m_stream` |
| Rows per table | 500,000,000 |
| TiFlash instance | `10.2.12.81:9522` |
| TiFlash status address | `10.2.12.81:20022` |
| Effective TiFlash code | `36d92ba35515dfcdf3d085c0f5239029a0b889ac` |
| TiFlash replica | count `1`, available `1`, progress `1` |
| Time zone | `+00:00` |
| Benchmark concurrency | one client, queries executed serially |

The TiFlash configuration file was:

```text
/DATA/disk2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml
```

There were no active `INSERT`, `UPDATE`, `DELETE`, or `REPLACE` statements on
either target table before or after its measured rounds.

## Workload

The checked-in `tiflash-benchmark.sql` was used after replacing only
`bc_bet_records_1m` with the table under test: `bc_bet_records_500m` or
`bc_bet_records_500m_stream`.

| Query | Workload |
| --- | --- |
| P01 | Three-hour selective aggregate |
| P02 | Twenty-seven-hour target aggregate |
| P03 | Three-day aggregate |
| P04 | Thirty-day aggregate |
| P05 | Outside-valid-interval fallback control |
| P06 | Production-shaped projection with TopN and `LIMIT 100` |

Every query used `ignore_plan_cache()` and a TiFlash storage hint. Each session
set:

```sql
SET time_zone = '+00:00';
SET SESSION tidb_isolation_read_engines = 'tiflash';
SET SESSION tidb_allow_mpp = 1;
SET SESSION tidb_enforce_mpp = 1;
```

All measured plans contained `mpp[tiflash]` and a TiFlash `TableFullScan`.

## Method

Only the unified `dt_enable_trim_minmax` setting was changed between rounds.
The following execution order was repeated independently for each table:

1. confirm `dt_enable_trim_minmax=false`;
2. run one disabled warm-up suite;
3. run five disabled measured suites;
4. hot-reload `dt_enable_trim_minmax=true`;
5. run one enabled warm-up suite;
6. run five enabled measured suites;
7. hot-reload `dt_enable_trim_minmax=false`;
8. run three additional disabled confirmation suites to check order and cache
   bias.

For `bc_bet_records_500m`, the enabled configuration was hot-reloaded at
`2026-07-21 09:12:38.338 +08:00`:

```text
reload delta tree config name: dt_enable_trim_minmax, old: 0, new: true;
```

Its final disabled configuration was hot-reloaded at
`2026-07-21 09:13:54.342 +08:00`:

```text
reload delta tree config name: dt_enable_trim_minmax, old: 1, new: false;
```

Per-query latency is the root operator `time` reported by `EXPLAIN ANALYZE`.
Client wall time measures the complete six-query suite, including connection,
transaction, planning, result transfer, and client overhead. Median latency is
the primary comparison statistic; means and observed ranges are included to
show run-to-run variation.

## Latency results for `bc_bet_records_500m`

| Query | Trim disabled median | Trim enabled median | Median change | Speedup |
| --- | ---: | ---: | ---: | ---: |
| P01 3h | 144.0 ms | 73.5 ms | **-49.0%** | 1.96x |
| P02 27h | 161.0 ms | 87.7 ms | **-45.5%** | 1.84x |
| P03 3d | 180.1 ms | 101.0 ms | **-43.9%** | 1.78x |
| P04 30d | 547.9 ms | 270.1 ms | **-50.7%** | 2.03x |
| P05 outside | 119.6 ms | 127.7 ms | +6.8% | 0.94x |
| P06 production | 338.9 ms | 298.5 ms | **-11.9%** | 1.14x |

The complete-suite client wall-time result was:

| Configuration | Median | Mean | Range |
| --- | ---: | ---: | ---: |
| Trim disabled | 2,125.5 ms | 2,125.0 ms | 2,088.2-2,172.3 ms |
| Trim enabled | 1,613.2 ms | 1,606.8 ms | 1,576.7-1,631.9 ms |

The complete suite improved by 24.1% at the median, corresponding to a 1.32x
speedup.

### Summary statistics

| Query | Disabled mean | Disabled range | Enabled mean | Enabled range |
| --- | ---: | ---: | ---: | ---: |
| P01 | 145.3 ms | 136.7-155.0 ms | 72.9 ms | 69.6-74.3 ms |
| P02 | 160.2 ms | 151.4-167.7 ms | 87.7 ms | 79.7-94.8 ms |
| P03 | 178.0 ms | 172.9-183.4 ms | 101.8 ms | 97.9-106.2 ms |
| P04 | 553.5 ms | 539.1-576.0 ms | 275.6 ms | 268.9-292.9 ms |
| P05 | 120.1 ms | 118.1-123.3 ms | 126.8 ms | 118.8-132.3 ms |
| P06 | 342.3 ms | 338.3-349.7 ms | 297.2 ms | 272.1-323.2 ms |

P05's ranges overlap. Its approximately 8 ms median difference should be
treated as fallback overhead or measurement variation, not as evidence of a
meaningful regression. It correctly provides no trim-pruning benefit.

## Raw measured latency samples for `bc_bet_records_500m`

All values below are milliseconds. The wall column is the complete-suite
client wall time.

### Trim disabled

| Run | P01 | P02 | P03 | P04 | P05 | P06 | Wall |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 155.0 | 167.7 | 180.1 | 557.8 | 119.6 | 349.7 | 2,130.0 |
| 2 | 143.5 | 165.6 | 173.3 | 539.1 | 123.3 | 338.9 | 2,125.5 |
| 3 | 144.0 | 155.3 | 183.4 | 576.0 | 118.1 | 346.1 | 2,172.3 |
| 4 | 136.7 | 161.0 | 180.2 | 546.6 | 118.8 | 338.6 | 2,109.2 |
| 5 | 147.2 | 151.4 | 172.9 | 547.9 | 120.9 | 338.3 | 2,088.2 |

### Trim enabled

| Run | P01 | P02 | P03 | P04 | P05 | P06 | Wall |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 73.5 | 94.8 | 106.2 | 277.4 | 127.7 | 323.2 | 1,616.3 |
| 2 | 69.6 | 79.7 | 104.2 | 292.9 | 118.8 | 313.5 | 1,595.7 |
| 3 | 73.7 | 91.6 | 99.6 | 270.1 | 129.5 | 298.5 | 1,613.2 |
| 4 | 73.3 | 84.8 | 97.9 | 268.9 | 125.8 | 278.9 | 1,576.7 |
| 5 | 74.3 | 87.7 | 101.0 | 268.9 | 132.3 | 272.1 | 1,631.9 |

## Physical scan results for `bc_bet_records_500m`

The `data_scanned_rows` value was stable across all five repetitions in each
configuration.

| Query | Trim disabled | Trim enabled | Reduction |
| --- | ---: | ---: | ---: |
| P01 | 896,497 | 847,345 | 5.5% |
| P02 | 6,630,598 | 6,499,526 | 2.0% |
| P03 | 17,062,186 | 16,914,730 | 0.9% |
| P04 | 352,644,577 | 167,695,864 | **52.4%** |
| P05 | 277,862,137 | 277,862,137 | 0.0% |
| P06 | 6,638,790 | 6,499,526 | 2.1% |

P04 demonstrates the largest physical pruning improvement. P01-P03 also show
substantial latency reduction with smaller changes in scanned rows, indicating
that the benefit includes avoiding ordinary min-max/rough-check work before
data reading, not only reducing the final `data_scanned_rows` counter.

## Execution-path counters for `bc_bet_records_500m`

Prometheus counters were sampled immediately before and after each five-run
measured block.

With trim min-max disabled:

| Counter | Increment |
| --- | ---: |
| `select_count{result="fallback_disabled"}` | 4,930 |

With trim min-max enabled:

| Counter | Increment |
| --- | ---: |
| `select_count{result="used"}` | 24,650 |
| `select_count{result="fallback_predicate_outside_range"}` | 4,930 |
| `rough_check_pack_count{result="all"}` | 53,520 |
| `rough_check_pack_count{result="some"}` | 68,695 |
| `rough_check_pack_count{result="none"}` | 1,416,710 |
| `correction_pack_count{type="all_to_some"}` | 66,415 |

The disabled block only incremented `fallback_disabled`. The enabled block
incremented `used` for P01-P04 and P06, while P05 incremented the expected
outside-range fallback. This proves that the measured A/B rounds exercised
the intended paths.

## Reverse-order confirmation for `bc_bet_records_500m`

After the enabled block, trim min-max was disabled again and three additional
confirmation suites were run. These samples were not added to the primary
five-sample comparison.

| Query | Initial disabled median | Final disabled confirmation median |
| --- | ---: | ---: |
| P01 | 144.0 ms | 152.6 ms |
| P02 | 161.0 ms | 159.2 ms |
| P03 | 180.1 ms | 191.1 ms |
| P04 | 547.9 ms | 545.2 ms |
| P05 | 119.6 ms | 127.6 ms |
| P06 | 338.9 ms | 359.4 ms |
| Complete-suite wall time | 2,125.5 ms | 2,354.9 ms |

Returning to the disabled configuration returned latency to the original
disabled range or higher. The enabled result was therefore not an artifact of
being measured later with warmer caches.

## Stream-imported table benchmark

The same method and P01-P06 workload were repeated for
`test.bc_bet_records_500m_stream`. This table contains the same generated
500-million-row data set, but its concurrent stream-import path produced a
different DMFile and pack layout. Its scan counters therefore differ slightly
from those of `bc_bet_records_500m` and were measured independently.

The stream table's enabled configuration was hot-reloaded at
`2026-07-21 10:09:00.455 +08:00`:

```text
reload delta tree config name: dt_enable_trim_minmax, old: 0, new: true;
```

Its final disabled configuration was hot-reloaded at
`2026-07-21 10:10:00.458 +08:00`:

```text
reload delta tree config name: dt_enable_trim_minmax, old: 1, new: false;
```

### Latency results

| Query | Trim disabled median | Trim enabled median | Median change | Speedup |
| --- | ---: | ---: | ---: | ---: |
| P01 3h | 129.6 ms | 64.9 ms | **-49.9%** | 2.00x |
| P02 27h | 146.3 ms | 74.4 ms | **-49.1%** | 1.97x |
| P03 3d | 165.4 ms | 108.1 ms | **-34.6%** | 1.53x |
| P04 30d | 541.4 ms | 288.1 ms | **-46.8%** | 1.88x |
| P05 outside | 116.2 ms | 120.2 ms | +3.4% | 0.97x |
| P06 production | 324.8 ms | 277.6 ms | **-14.5%** | 1.17x |

The complete-suite client wall-time result was:

| Configuration | Median | Mean | Range |
| --- | ---: | ---: | ---: |
| Trim disabled | 2,066.3 ms | 2,062.3 ms | 2,035.1-2,072.7 ms |
| Trim enabled | 1,552.7 ms | 1,581.2 ms | 1,533.0-1,682.2 ms |

The complete stream-table suite improved by 24.9% at the median,
corresponding to a 1.33x speedup.

### Summary statistics

| Query | Disabled mean | Disabled range | Enabled mean | Enabled range |
| --- | ---: | ---: | ---: | ---: |
| P01 | 135.8 ms | 125.7-157.1 ms | 67.9 ms | 58.4-80.9 ms |
| P02 | 145.7 ms | 140.3-151.1 ms | 78.2 ms | 70.8-87.6 ms |
| P03 | 166.1 ms | 162.3-172.3 ms | 108.7 ms | 103.0-115.6 ms |
| P04 | 543.6 ms | 536.6-550.9 ms | 287.7 ms | 283.6-291.4 ms |
| P05 | 118.9 ms | 114.9-124.7 ms | 120.7 ms | 116.5-127.6 ms |
| P06 | 325.3 ms | 305.0-349.6 ms | 274.8 ms | 260.4-293.2 ms |

P05's ranges overlap and its scan count is unchanged. The approximately 4 ms
median difference is not evidence of a meaningful regression; the query
correctly receives no trim-pruning benefit.

### Raw measured latency samples

All values below are milliseconds. The wall column is the complete-suite
client wall time.

#### Trim disabled

| Run | P01 | P02 | P03 | P04 | P05 | P06 | Wall |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 157.1 | 151.1 | 165.4 | 548.4 | 114.9 | 318.1 | 2,066.3 |
| 2 | 125.7 | 143.6 | 162.3 | 550.9 | 115.6 | 324.8 | 2,071.4 |
| 3 | 127.3 | 147.0 | 166.8 | 541.4 | 116.2 | 305.0 | 2,035.1 |
| 4 | 139.3 | 146.3 | 163.6 | 540.6 | 123.3 | 328.8 | 2,066.2 |
| 5 | 129.6 | 140.3 | 172.3 | 536.6 | 124.7 | 349.6 | 2,072.7 |

#### Trim enabled

| Run | P01 | P02 | P03 | P04 | P05 | P06 | Wall |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 80.9 | 87.6 | 107.0 | 291.4 | 127.6 | 293.2 | 1,599.3 |
| 2 | 71.1 | 71.8 | 103.0 | 288.1 | 116.5 | 262.2 | 1,682.2 |
| 3 | 64.1 | 74.4 | 108.1 | 284.4 | 117.0 | 280.7 | 1,533.0 |
| 4 | 64.9 | 86.4 | 109.6 | 283.6 | 122.2 | 277.6 | 1,552.7 |
| 5 | 58.4 | 70.8 | 115.6 | 290.9 | 120.2 | 260.4 | 1,538.9 |

### Physical scan results

The `data_scanned_rows` value was stable across all five repetitions in each
configuration.

| Query | Trim disabled | Trim enabled | Reduction |
| --- | ---: | ---: | ---: |
| P01 | 869,558 | 828,598 | 4.7% |
| P02 | 6,025,777 | 5,935,665 | 1.5% |
| P03 | 16,454,193 | 16,339,505 | 0.7% |
| P04 | 352,415,756 | 167,133,853 | **52.6%** |
| P05 | 278,239,318 | 278,239,318 | 0.0% |
| P06 | 6,033,969 | 5,935,665 | 1.6% |

As on the regular-import table, P04 shows the largest physical pruning
improvement. P01-P03 receive substantial latency reductions with smaller
changes in final scanned rows.

### Execution-path counters

With trim min-max disabled:

| Counter | Increment |
| --- | ---: |
| `select_count{result="fallback_disabled"}` | 2,800 |

With trim min-max enabled:

| Counter | Increment |
| --- | ---: |
| `select_count{result="used"}` | 14,000 |
| `select_count{result="fallback_predicate_outside_range"}` | 2,800 |
| `rough_check_pack_count{result="all"}` | 52,320 |
| `rough_check_pack_count{result="some"}` | 67,950 |
| `rough_check_pack_count{result="none"}` | 1,411,055 |
| `correction_pack_count{type="all_to_some"}` | 65,590 |

The counters prove that P01-P04 and P06 used trim min-max in the enabled
block, while P05 followed the expected outside-range fallback. The disabled
block only incremented `fallback_disabled`.

### Reverse-order confirmation

After the enabled block, three additional disabled suites were run and were
not added to the primary five-sample comparison.

| Query | Initial disabled median | Final disabled confirmation median |
| --- | ---: | ---: |
| P01 | 129.6 ms | 139.9 ms |
| P02 | 146.3 ms | 147.1 ms |
| P03 | 165.4 ms | 177.4 ms |
| P04 | 541.4 ms | 554.2 ms |
| P05 | 116.2 ms | 117.6 ms |
| P06 | 324.8 ms | 302.8 ms |
| Complete-suite wall time | 2,066.3 ms | 2,093.1 ms |

The complete suite returned to the disabled range after trim min-max was
turned off. This rules out later execution and warmer caches as the source of
the enabled block's improvement.

## Scope and conclusion

This is a warm-cache, single-client latency benchmark on one TiFlash node. It
does not measure concurrent throughput, cold-start behavior, multi-node MPP,
or long-duration production workload variance.

Within this scope, trim min-max provides a clear benefit for eligible temporal
predicates on both import layouts:

- on `bc_bet_records_500m`, P01-P04 improve by 43.9%-50.7%, P06 improves by
  11.9%, and the complete suite improves by 24.1%;
- on `bc_bet_records_500m_stream`, P01-P04 improve by 34.6%-49.9%, P06
  improves by 14.5%, and the complete suite improves by 24.9%;
- P05 correctly falls back and receives no pruning benefit.

The node was left in its original disabled state after the benchmark:

```toml
dt_enable_trim_minmax = false
```
