-- Correctness gate for test.bc_bet_records_1m.
--
-- Run this exact file once with trim reads disabled and once with trim reads
-- enabled, capture both outputs, and diff them. Every query returns a row count
-- plus an exact checksum based on the generated row number.
--
-- TiFlash profile A (ordinary min-max):
--   dt_enable_trim_minmax_write = true
--   dt_enable_trim_minmax_read = false
--   dt_enable_rough_set_filter = true
-- TiFlash profile B (trim min-max):
--   dt_enable_trim_minmax_write = true
--   dt_enable_trim_minmax_read = true
--   dt_enable_rough_set_filter = true
--
-- These are TiFlash [profiles.default] settings, not TiDB session variables.

SET time_zone = '+00:00';
SET SESSION tidb_isolation_read_engines = 'tiflash';
SET SESSION tidb_allow_mpp = 1;
SET SESSION tidb_enforce_mpp = 1;

-- Q01: target 27-hour query. Expected: 3053, 3034024140.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q01_target_27h' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';

-- Q02-Q04: selectivity curve inside the valid interval.
-- Expected Q02: 352, 351756951.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q02_target_3h' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-15 21:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';

-- Expected Q03: 8240, 8102520948.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q03_target_3d' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-13 00:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';

-- Expected Q04: 83094, 69237508479.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q04_target_30d' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-06-16 00:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';

-- Q05: outside the valid interval; must fall back to ordinary min-max.
-- Expected: 102, 49034523.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q05_datetime_outside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.settle_time = '2100-01-01 00:00:00';

-- Q06-Q07: same DATETIME column has one eligible and one ineligible range.
-- Operand order must not affect the result. Expected for both:
-- 12602, 12470915773.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q06_mixed_or_inside_first' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
   OR b.settle_time = '2100-01-01 00:00:00';

SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q07_mixed_or_outside_first' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.settle_time = '2100-01-01 00:00:00'
   OR b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59';

-- Q08-Q09: DATE inside/outside behavior.
-- Expected Q08: 22222, 21975094905.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q08_date_inside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.settle_date BETWEEN '2026-07-14' AND '2026-07-15';

-- Expected Q09: 102, 49034523.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q09_date_outside' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.settle_date = '2100-01-01';

-- Q10: NULL bound. Expected: 0, 0. TiDB may fold this to an empty plan;
-- retain it as a SQL-level semantic guard, but also cover this in TiFlash UT.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q10_null_bound' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.settle_time > NULL;

-- Q11: mixed eligible/ineligible values represented as IN. Expected:
-- 102, 49034523.
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    'Q11_mixed_in' AS case_name,
    COUNT(*) AS row_count,
    COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
FROM test.bc_bet_records_1m AS b
WHERE b.settle_time IN ('2026-07-14 21:00:00', '2100-01-01 00:00:00');
