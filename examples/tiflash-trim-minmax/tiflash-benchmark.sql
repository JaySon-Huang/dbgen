-- TiFlash trim min-max performance suite for test.bc_bet_records_1m.
-- Run tiflash-precheck.sql and tiflash-correctness.sql first.
--
-- Run this same file in two rounds and compare EXPLAIN ANALYZE output:
--   A: dt_enable_trim_minmax_read=false, dt_enable_rough_set_filter=true
--   B: dt_enable_trim_minmax_read=true,  dt_enable_rough_set_filter=true
-- Keep dt_enable_trim_minmax_write=true in both rounds.
-- Optional lower-bound round:
--   C: dt_enable_trim_minmax_read=false, dt_enable_rough_set_filter=false
--
-- Run each round once as warm-up, then at least five measured repetitions.
-- Every query uses a separate transaction. The printed query_tso is the same
-- value recorded as query_tso/start_ts in TiFlash MPPTaskStatistics logs.

SET time_zone = '+00:00';
SET SESSION tidb_isolation_read_engines = 'tiflash';
SET SESSION tidb_allow_mpp = 1;
SET SESSION tidb_enforce_mpp = 1;

-- P01: 3-hour micro benchmark, highest selectivity.
BEGIN;
SELECT 'P01_3h' AS query_name, @@tidb_current_ts AS query_tso;
EXPLAIN ANALYZE
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */ COUNT(*)
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-15 21:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';
ROLLBACK;

-- P02: target 27-hour micro benchmark.
BEGIN;
SELECT 'P02_27h' AS query_name, @@tidb_current_ts AS query_tso;
EXPLAIN ANALYZE
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */ COUNT(*)
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';
ROLLBACK;

-- P03: 3-day micro benchmark.
BEGIN;
SELECT 'P03_3d' AS query_name, @@tidb_current_ts AS query_tso;
EXPLAIN ANALYZE
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */ COUNT(*)
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-07-13 00:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';
ROLLBACK;

-- P04: 30-day micro benchmark. This shows where trim benefit tapers off.
BEGIN;
SELECT 'P04_30d' AS query_name, @@tidb_current_ts AS query_tso;
EXPLAIN ANALYZE
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */ COUNT(*)
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time BETWEEN '2026-06-16 00:00:00' AND '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY';
ROLLBACK;

-- P05: outside-valid-interval fallback control. Trim ON should neither change
-- the result nor materially improve pack pruning for this query.
BEGIN;
SELECT 'P05_outside' AS query_name, @@tidb_current_ts AS query_tso;
EXPLAIN ANALYZE
SELECT /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */ COUNT(*)
FROM test.bc_bet_records_1m AS b
WHERE b.settle_time = '2100-01-01 00:00:00';
ROLLBACK;

-- P06: original production-shaped query. This includes projection, TopN and
-- LIMIT overhead and is the primary end-to-end measurement.
BEGIN;
SELECT 'P06_production' AS query_name, @@tidb_current_ts AS query_tso;
EXPLAIN ANALYZE
SELECT
    /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    b.record_id,
    b.order_no,
    b.round_id,
    b.account,
    b.third_user_name,
    b.third_game_code,
    b.site_code,
    b.platform_id,
    b.category_id AS gameCategoryId,
    b.bet_time,
    b.settle_time,
    b.all_bet,
    b.valid_bet,
    b.net_profit,
    b.after_balance,
    b.tax,
    b.rake,
    b.insurance,
    b.props,
    b.settle_status,
    b.winlost_time,
    b.pull_time,
    b.currency,
    b.game_id,
    b.device,
    b.odds_type,
    b.odds,
    b.is_combo
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time >= '2026-07-14 21:00:00'
  AND b.settle_time <= '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY'
ORDER BY b.settle_time DESC, b.id DESC
LIMIT 100;
ROLLBACK;
