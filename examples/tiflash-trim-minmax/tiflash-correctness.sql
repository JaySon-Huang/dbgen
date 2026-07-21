-- Correctness gate for test.bc_bet_records_500m.
--
-- Run this exact file three times and diff the query outputs:
--   1. TiKV, as the SQL-semantics oracle;
--   2. TiFlash with dt_enable_trim_minmax=false, as the ordinary min-max baseline;
--   3. TiFlash with dt_enable_trim_minmax=true, as the trim min-max candidate.
--
-- Select the engine with mycli --init-command, for example:
--   --init-command "SET @correctness_engine='tikv'"
--   --init-command "SET @correctness_engine='tiflash'"
--
-- Q01-Q32 return exact counts/checksums derived from the generated row number.
-- Q33 returns a deterministic, complete 100-row result set for TopN/LIMIT.
-- Do not write to the table or rebuild its TiFlash replica between the three
-- rounds.
--
-- TiFlash profile A (ordinary min-max):
--   dt_enable_trim_minmax = false
--   dt_enable_rough_set_filter = true
-- TiFlash profile B (trim min-max):
--   dt_enable_trim_minmax = true
--   dt_enable_rough_set_filter = true
--
-- These are TiFlash [profiles.default] settings, not TiDB session variables.

SET time_zone = '+00:00';
SET @correctness_engine = COALESCE(@correctness_engine, 'tiflash');
SET SESSION tidb_isolation_read_engines = @correctness_engine;
SET SESSION tidb_allow_mpp = (@correctness_engine = 'tiflash');
SET SESSION tidb_enforce_mpp = (@correctness_engine = 'tiflash');

-- Q01: target 27-hour query. Expected: 3053, 3034024140.
SELECT /*+ ignore_plan_cache() */
    'Q01_target_27h' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';

-- Q02-Q04: selectivity curve inside the valid interval.
-- Expected Q02: 352, 351756951.
SELECT /*+ ignore_plan_cache() */
    'Q02_target_3h' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-15 21:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';

-- Expected Q03: 8240, 8102520948.
SELECT /*+ ignore_plan_cache() */
    'Q03_target_3d' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-13 00:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';

-- Expected Q04: 83094, 69237508479.
SELECT /*+ ignore_plan_cache() */
    'Q04_target_30d' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-06-16 00:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';

-- Q05: outside the valid interval; must fall back to ordinary min-max.
-- Expected: 102, 49034523.
SELECT /*+ ignore_plan_cache() */
    'Q05_datetime_outside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time = '2100-01-01 00:00:00';

-- Q06-Q07: same DATETIME column has one eligible and one ineligible range.
-- Operand order must not affect the result. Expected for both:
-- 12602, 12470915773.
SELECT /*+ ignore_plan_cache() */
    'Q06_mixed_or_inside_first' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
   OR b.settle_time = '2100-01-01 00:00:00';

SELECT /*+ ignore_plan_cache() */
    'Q07_mixed_or_outside_first' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time = '2100-01-01 00:00:00'
   OR b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59';

-- Q08-Q09: DATE inside/outside behavior.
-- Expected Q08: 22222, 21975094905.
SELECT /*+ ignore_plan_cache() */
    'Q08_date_inside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_date BETWEEN '2026-07-14' AND '2026-07-15';

-- Expected Q09: 102, 49034523.
SELECT /*+ ignore_plan_cache() */
    'Q09_date_outside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_date = '2100-01-01';

-- Q10: NULL bound. Expected: 0, 0. TiDB may fold this to an empty plan;
-- retain it as a SQL-level semantic guard, but also cover this in TiFlash UT.
SELECT /*+ ignore_plan_cache() */
    'Q10_null_bound' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time > NULL;

-- Q11: mixed eligible/ineligible values represented as IN. Expected:
-- 102, 49034523.
SELECT /*+ ignore_plan_cache() */
    'Q11_mixed_in' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time IN ('2026-07-14 21:00:00', '2100-01-01 00:00:00');

-- Q12-Q13: eligible equality and IN predicates wholly inside E.
-- Expected Q12: 1, 1000000.
SELECT /*+ ignore_plan_cache() */
    'Q12_equal_inside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time = '2026-07-15 23:59:59';

-- Expected Q13: 2, 1000001.
SELECT /*+ ignore_plan_cache() */
    'Q13_in_inside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time IN ('2026-04-17 00:00:00', '2026-07-15 23:59:59');

-- Q14-Q17: all four one-sided comparisons. The lower-bound cases must retain
-- the matching high-trimmed 2100 sentinel rows.
-- Expected Q14: 103, 50034523.
SELECT /*+ ignore_plan_cache() */
    'Q14_lower_inclusive' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time >= '2026-07-15 23:59:59';

-- Expected Q15: 102, 49034523.
SELECT /*+ ignore_plan_cache() */
    'Q15_lower_exclusive' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time > '2026-07-15 23:59:59';

-- Expected Q16: 1, 1.
SELECT /*+ ignore_plan_cache() */
    'Q16_upper_inclusive' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time <= '2026-04-17 00:00:00';

-- Expected Q17: 0, 0.
SELECT /*+ ignore_plan_cache() */
    'Q17_upper_exclusive' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time < '2026-04-17 00:00:00';

-- Q18-Q20: explicit GE/LE and GT/LT normalization. AND operand order must not
-- affect the normalized DateRange or the result.
-- Expected Q18-Q19: 12500, 12421881250.
SELECT /*+ ignore_plan_cache() */
    'Q18_and_normal_order' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time >= '2026-07-14 21:00:00'
  AND b.settle_time <= '2026-07-15 23:59:59';

SELECT /*+ ignore_plan_cache() */
    'Q19_and_reversed_order' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time <= '2026-07-15 23:59:59'
  AND b.settle_time >= '2026-07-14 21:00:00';

-- Expected Q20: 12499, 12420881250.
SELECT /*+ ignore_plan_cache() */
    'Q20_exclusive_range' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time > '2026-07-14 21:00:00'
  AND b.settle_time < '2026-07-15 23:59:59';

-- Q21-Q23: the exclusive upper edge of E is 2099-12-01 00:00:00.
-- Q21 is eligible; Q22-Q23 must fall back to ordinary min-max.
-- Expected Q21-Q22: 0, 0. Expected Q23: 102, 49034523.
SELECT /*+ ignore_plan_cache() */
    'Q21_upper_edge_inside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time = '2099-11-30 23:59:59';

SELECT /*+ ignore_plan_cache() */
    'Q22_upper_edge_outside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time = '2099-12-01 00:00:00';

SELECT /*+ ignore_plan_cache() */
    'Q23_above_upper_edge' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time >= '2099-12-01 00:00:00';

-- Q24-Q30: unsupported or NULL-sensitive expression shapes must preserve SQL
-- semantics through ordinary min-max fallback.
-- Expected Q24: 999898, 499951465477.
SELECT /*+ ignore_plan_cache() */
    'Q24_not_equal' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time <> '2100-01-01 00:00:00';

-- Expected Q25: 987500, 487578618750.
SELECT /*+ ignore_plan_cache() */
    'Q25_not_between' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE NOT (b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59');

-- Expected Q26: 12602, 12470915773.
SELECT /*+ ignore_plan_cache() */
    'Q26_or_non_temporal' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
   OR b.settle_status = 1;

-- Expected Q27: 12500, 12421881250.
SELECT /*+ ignore_plan_cache() */
    'Q27_or_is_null' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
   OR b.settle_time IS NULL;

-- Expected Q28: 11111, 11049278395.
SELECT /*+ ignore_plan_cache() */
    'Q28_cast_fallback' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE CAST(b.settle_time AS DATE) = '2026-07-15';

-- Expected Q29: 103, 50034523. Expected Q30: 0, 0.
SELECT /*+ ignore_plan_cache() */
    'Q29_in_with_null' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time IN ('2026-07-15 23:59:59', '2100-01-01 00:00:00', NULL);

SELECT /*+ ignore_plan_cache() */
    'Q30_not_in_with_null' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time NOT IN ('2026-07-15 23:59:59', '2100-01-01 00:00:00', NULL);

-- Q31: top-level DateRange plus an OR containing independently eligible and
-- ineligible equality leaves. Expected: 1, 1000000.
SELECT /*+ ignore_plan_cache() */
    'Q31_mixed_tree' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time >= '2026-07-14 21:00:00'
  AND b.settle_time <= '2026-07-15 23:59:59'
  AND (b.settle_time = '2026-07-15 23:59:59'
       OR b.settle_time = '2100-01-01 00:00:00');

-- Q32: aggregation result shape. Expected:
--   status 2: 12481, 12402982983
--   status 3:    19,    18898267
SELECT /*+ ignore_plan_cache() */
    'Q32_group_recent' AS case_name,
    b.settle_status,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_500m AS b
WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
GROUP BY b.settle_status
ORDER BY b.settle_status;

-- Q33: deterministic complete result set for SELECT + TopN + LIMIT. The raw
-- 100 rows, not only an aggregate, must be identical in all three rounds.
SELECT /*+ ignore_plan_cache() */
    'Q33_topn_limit' AS case_name,
    b.id,
    b.record_id,
    b.order_no,
    b.category_id,
    b.settle_time,
    b.settle_status,
    b.settle_date
FROM test.bc_bet_records_500m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY'
ORDER BY b.settle_time DESC, b.id DESC
LIMIT 100;
