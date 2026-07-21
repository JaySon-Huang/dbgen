# 500-million-row correctness report

## Status

Validation of `test.bc_bet_records_500m` and the stream-imported
`test.bc_bet_records_500m_stream` was updated on 2026-07-20.

The complete correctness gate passed. Completed checks:

1. the imported data satisfies the generator invariants;
2. TiFlash executed the complete Q01-Q33 suite with
   `dt_enable_trim_minmax=false`;
3. TiFlash executed the same Q01-Q33 suite with
   `dt_enable_trim_minmax=true`;
4. TiKV executed the complete Q01-Q33 suite and saved its output in
   `tiflash-correctness-tikv_result.sql`;
5. the TiKV, trim-disabled TiFlash, and trim-enabled TiFlash outputs each
   contain 133 result rows and are identical line by line, including exact
   counts, checksums, grouped rows, and the complete 100-row TopN result.

The same data-invariant and complete Q01-Q33 checks also passed for
`bc_bet_records_500m_stream`. Its trim-disabled and trim-enabled TiFlash
outputs are identical to each other and to the saved TiKV result for
`bc_bet_records_500m`.

## Environment

| Item | Value |
| --- | --- |
| TiDB endpoint | `10.2.12.79:8020` |
| Database and tables | `test.bc_bet_records_500m`, `test.bc_bet_records_500m_stream` |
| TiFlash instance | `10.2.12.81:9522` |
| TiFlash status address | `10.2.12.81:20022` |
| TiFlash version | `8.5.4-20260713-4b2815a-5-g7d70c1ce4d` |
| TiFlash Git hash | `7d70c1ce4d09cc018080a638e6a450018ff0e388` |
| TiFlash replica | count `1`, available `1`, progress `1` |
| Time zone | `+00:00` |

The configuration file is
`/DATA/disk2/jaysonhuang/clusters/tiflash-5022/conf/tiflash.toml`.

The disabled round was hot-reloaded at `2026-07-20 15:36:32.170 +08:00`:

```text
reload delta tree config name: dt_enable_trim_minmax, old: 1, new: false;
```

The enabled round was hot-reloaded at `2026-07-20 15:55:54.210 +08:00`:

```text
reload delta tree config name: dt_enable_trim_minmax, old: 0, new: true;
```

After validating `bc_bet_records_500m`, the configuration was enabled. The
stream-imported table was then tested in both states. The final configuration
after all recorded checks is:

```toml
dt_enable_trim_minmax = false
```

## Data invariant check

TiKV and TiFlash independently executed the same full-table aggregate. All 16
returned fields were identical.

| Check | Result |
| --- | ---: |
| Total rows | 500,000,000 |
| Minimum generated row number | 1 |
| Maximum generated row number | 500,000,000 |
| Sum of generated row numbers | 125,000,000,250,000,000 |
| Sentinel rows at `2100-01-01 00:00:00` | 49,748 |
| NULL `settle_time` rows | 0 |
| Minimum normal `settle_time` | `2026-04-17 00:00:00` |
| Maximum normal `settle_time` | `2026-07-15 23:59:59` |
| `settle_status=1` | 49,748 |
| `settle_status=2` | 499,450,747 |
| `settle_status=3` | 499,505 |
| Other settle statuses | 0 |
| `category_id=5` | 124,999,205 |
| Rows whose `site_code` is not `213` | 0 |
| Rows whose `currency` is not `CNY` | 0 |
| Rows whose `settle_date` differs from `DATE(settle_time)` | 0 |

The primary key makes row IDs unique. A count of 500,000,000 together with the
exact minimum, maximum, and sum demonstrates that the generated row-number
range `1..500000000` was imported completely.

## Complete TiFlash Q01-Q33 comparison

The checked-in `tiflash-correctness.sql` was executed after replacing only the
table name `bc_bet_records_1m` with `bc_bet_records_500m`. The table was not
written to or rebuilt between the disabled and enabled rounds. Q01-Q31 use
`SUM(id - 7000000000000000000)` as an exact row-set checksum; Q32 returns two
grouped rows; Q33 returns a complete deterministic 100-row result.

The values below were identical in TiKV, trim-disabled TiFlash, and
trim-enabled TiFlash.

| Case | Row count | Checksum |
| --- | ---: | ---: |
| Q01 | 1,561,136 | 775,692,823,239,671 |
| Q02 | 173,647 | 86,763,277,315,052 |
| Q03 | 4,164,543 | 2,047,562,491,651,402 |
| Q04 | 41,629,884 | 17,345,917,947,854,190 |
| Q05 | 49,748 | 12,436,870,022,534 |
| Q06 | 6,299,025 | 3,117,546,528,755,788 |
| Q07 | 6,299,025 | 3,117,546,528,755,788 |
| Q08 | 11,109,920 | 5,493,238,388,822,153 |
| Q09 | 49,748 | 12,436,870,022,534 |
| Q10 | 0 | 0 |
| Q11 | 49,812 | 12,468,470,028,646 |
| Q12 | 1 | 500,000,000 |
| Q13 | 66 | 500,002,145 |
| Q14 | 49,749 | 12,437,370,022,534 |
| Q15 | 49,748 | 12,436,870,022,534 |
| Q16 | 65 | 2,145 |
| Q17 | 0 | 0 |
| Q18 | 6,249,277 | 3,105,109,658,733,254 |
| Q19 | 6,249,277 | 3,105,109,658,733,254 |
| Q20 | 6,249,212 | 3,105,077,558,727,142 |
| Q21 | 0 | 0 |
| Q22 | 0 | 0 |
| Q23 | 49,748 | 12,436,870,022,534 |
| Q24 | 499,950,252 | 124,987,563,379,977,466 |
| Q25 | 493,750,723 | 121,894,890,591,266,746 |
| Q26 | 6,299,025 | 3,117,546,528,755,788 |
| Q27 | 6,249,277 | 3,105,109,658,733,254 |
| Q28 | 5,554,901 | 2,762,020,361,328,129 |
| Q29 | 49,749 | 12,437,370,022,534 |
| Q30 | 0 | 0 |
| Q31 | 1 | 500,000,000 |

Q32 returned the same two groups in both TiFlash rounds:

| `settle_status` | Row count | Checksum |
| ---: | ---: | ---: |
| 2 | 6,243,076 | 3,102,028,870,556,078 |
| 3 | 6,201 | 3,080,788,177,176 |

Q33 returned the same complete 100-row sequence in all three engine rounds.
Its first and last rows were:

| Position | ID | Record ID | Settle time |
| --- | ---: | --- | --- |
| First | 7,000,000,000,500,000,000 | `rec-500000000` | `2026-07-15 23:59:59` |
| 100th | 7,000,000,000,499,999,605 | `rec-499999605` | `2026-07-15 23:59:52` |

The machine comparison covered all 133 output rows and found no difference
between TiKV, ordinary min-max TiFlash, and trim min-max TiFlash.

## TiKV result capture and three-way comparison

The TiKV interactive transcript is stored in
`tiflash-correctness-tikv_result.sql`. It records the session configuration:

```text
@@tidb_isolation_read_engines = tikv
@@tidb_allow_mpp = 0
@@tidb_enforce_mpp = 0
```

The transcript targets `test.bc_bet_records_500m`. After removing mycli
prompts, table borders, column headings, timing records, and padding around
cells, 133 result rows remained:

- 31 rows from Q01-Q31;
- 2 grouped rows from Q32;
- 100 ordered rows from Q33.

The same normalization was applied to the previously captured TiFlash
outputs. Machine comparison reported:

```text
TiKV rows:                  133
trim-disabled TiFlash rows: 133
trim-enabled TiFlash rows:  133
TiKV == trim-disabled:      true
TiKV == trim-enabled:       true
trim-disabled == enabled:   true
first differing row:        none
```

## TiFlash path coverage for the complete suite

Prometheus counters were sampled immediately before and after each complete
TiFlash Q01-Q33 round. The counters are global and cumulative, so their deltas
are used as execution-path evidence; result equality remains the correctness
gate.

With trim min-max disabled, the observed increment was:

| Counter | Increment |
| --- | ---: |
| `select_count{result="fallback_disabled"}` | 10,846 |

With trim min-max enabled, the observed increments were:

| Counter | Increment |
| --- | ---: |
| `select_count{result="used"}` | 20,438 |
| `select_count{result="fallback_predicate_outside_range"}` | 6,184 |
| `rough_check_pack_count{result="all"}` | 12,865 |
| `rough_check_pack_count{result="some"}` | 114,450 |
| `rough_check_pack_count{result="none"}` | 1,148,626 |
| `correction_pack_count{type="all_to_some"}` | 16,178 |
| `correction_pack_count{type="none_to_some"}` | 97,432 |

`select_count{result="used"}` did not increase during the disabled round. This
confirms that the first complete TiFlash result used ordinary min-max, while
the enabled round selected trim min-max and exercised range fallback and both
correction directions.

## Stream-imported table validation

The same correctness gate was repeated for
`test.bc_bet_records_500m_stream`, which was populated by the concurrent
stream loader. There were no active `INSERT`, `UPDATE`, `DELETE`, or `REPLACE`
statements on the table during either query round. Its TiFlash replica had
count `1`, available `1`, and progress `1`.

### Import invariants

TiFlash executed the full-table invariant aggregate before the query suite.
All 16 fields were identical to the values recorded above for
`bc_bet_records_500m`, including:

| Check | Stream-imported result |
| --- | ---: |
| Total rows | 500,000,000 |
| Generated row-number range | 1 to 500,000,000 |
| Sum of generated row numbers | 125,000,000,250,000,000 |
| Sentinel rows at `2100-01-01 00:00:00` | 49,748 |
| NULL `settle_time` rows | 0 |
| `settle_status=1` / `2` / `3` | 49,748 / 499,450,747 / 499,505 |
| Other settle statuses | 0 |
| `category_id=5` | 124,999,205 |
| Invalid site, currency, or derived settle date | 0 |

This confirms that the stream loader imported the expected generated range
and distributions without missing or duplicate primary-key rows.

### Complete Q01-Q33 comparison

The complete `tiflash-correctness.sql` suite was run twice after replacing
only `bc_bet_records_1m` with `bc_bet_records_500m_stream`. Both runs returned
all 133 normalized result rows: one row each for Q01-Q31, two grouped rows for
Q32, and the complete ordered 100-row Q33 result.

The saved TiKV transcript targets `bc_bet_records_500m`, so it was reused as
the expected-result oracle rather than rescanning the stream-imported table
through TiKV. This is valid for this gate because both tables contain the same
generated data set, their invariant results match, and every Q01-Q33 output
from the stream-imported table matches the oracle exactly.

| Comparison | Rows compared | Differing rows |
| --- | ---: | ---: |
| Stream table, trim enabled vs. trim disabled | 133 | 0 |
| Stream table, trim enabled vs. saved TiKV oracle | 133 | 0 |
| Stream table, trim disabled vs. saved TiKV oracle | 133 | 0 |

The first Q01 row and final Q33 row provide boundary examples from the exact
comparison:

```text
Q01_target_27h  1561136  775692823239671
Q33_topn_limit  7000000000499999605  rec-499999605  ord-499999605  5  2026-07-15 23:59:52  2  2026-07-15
```

### Execution-path evidence

With trim min-max enabled, the Q01-Q33 round produced these counter deltas:

| Counter | Increment |
| --- | ---: |
| `select_count{result="used"}` | 20,438 |
| `select_count{result="fallback_predicate_outside_range"}` | 6,184 |
| `rough_check_pack_count{result="all"}` | 12,865 |
| `rough_check_pack_count{result="some"}` | 114,450 |
| `rough_check_pack_count{result="none"}` | 1,148,626 |
| `correction_pack_count{type="all_to_some"}` | 16,178 |
| `correction_pack_count{type="none_to_some"}` | 97,432 |

The single TiFlash node then hot-reloaded the disabled configuration at
`2026-07-20 22:34:59.026 +08:00`:

```text
reload delta tree config name: dt_enable_trim_minmax, old: 1, new: false;
```

During the disabled Q01-Q33 round, only the expected disabled-path counter
increased:

| Counter | Increment |
| --- | ---: |
| `select_count{result="fallback_disabled"}` | 10,846 |

The enabled counters prove that the trim min-max selection, outside-range
fallback, rough-check, and correction paths were exercised. The disabled
counter proves that the comparison round bypassed trim min-max. The final
node configuration remains `dt_enable_trim_minmax=false`.

## Test scope

Pack-level low/high/NULL/delete-mark combinations, fractional temporal types,
and malformed index payloads remain unit-test responsibilities rather than
end-to-end data-set cases.

## Conclusion

Both the original and stream-imported 500-million-row tables pass their import
invariants. For `bc_bet_records_500m`, the complete Q01-Q33 result is identical
between TiKV, trim-disabled TiFlash, and trim-enabled TiFlash. For
`bc_bet_records_500m_stream`, the trim-disabled and trim-enabled TiFlash
results are identical to each other and to the saved TiKV oracle. The metrics
prove that the intended disabled, trim-used, outside-range fallback, and
correction paths were exercised in both table checks. Both SQL correctness
gates passed.
