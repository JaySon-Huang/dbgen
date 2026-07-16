-- Preflight checks for test.bc_bet_records_1m.
-- This file is read-only. Run it before every correctness/performance round.

SET time_zone = '+00:00';

-- Expected now: REPLICA_COUNT=2, AVAILABLE=1, PROGRESS=1.
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    REPLICA_COUNT,
    AVAILABLE,
    PROGRESS
FROM information_schema.tiflash_replica
WHERE TABLE_SCHEMA = 'test'
  AND TABLE_NAME = 'bc_bet_records_1m';

SELECT
    @@tidb_isolation_read_engines AS isolation_read_engines,
    @@tidb_allow_mpp AS allow_mpp,
    @@tidb_enforce_mpp AS enforce_mpp,
    @@time_zone AS session_time_zone;

-- Dataset identity checks. Expected: 1,000,000 rows and 102 sentinel rows.
SELECT
    COUNT(*) AS row_count,
    MIN(id) AS min_id,
    MAX(id) AS max_id,
    SUM(settle_time = '2100-01-01 00:00:00') AS sentinel_rows,
    MIN(CASE WHEN settle_time < '2100-01-01 00:00:00' THEN settle_time END) AS min_normal_time,
    MAX(CASE WHEN settle_time < '2100-01-01 00:00:00' THEN settle_time END) AS max_normal_time
FROM test.bc_bet_records_1m;

-- If the plan reports stats:pseudo, ANALYZE may be run once before all A/B
-- rounds. Do not run it between A and B because that changes another variable.
-- ANALYZE TABLE test.bc_bet_records_1m;

-- The physical plan must contain an mpp[tiflash] TableFullScan. If it falls
-- back to TiKV, stop: the following benchmark would not measure trim min-max.
EXPLAIN FORMAT = 'brief'
SELECT
    /*+ ignore_plan_cache() read_from_storage(tiflash[b]) */
    b.record_id,
    b.order_no,
    b.settle_time
FROM test.bc_bet_records_1m AS b
WHERE b.category_id = 5
  AND b.settle_status = 2
  AND b.settle_time >= '2026-07-14 21:00:00'
  AND b.settle_time <= '2026-07-15 23:59:59'
  AND b.site_code = '213'
  AND b.currency = 'CNY'
ORDER BY b.settle_time DESC
LIMIT 100;
