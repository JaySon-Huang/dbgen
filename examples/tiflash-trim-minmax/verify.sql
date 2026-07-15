SELECT COUNT(*) AS total_rows
FROM bc_bet_records_213;

SELECT
    SUM(settle_time = '2100-01-01 00:00:00') AS sentinel_rows,
    COUNT(*) / 10000 AS expected_at_probability_1e_4
FROM bc_bet_records_213;

SELECT
    MIN(settle_time) AS min_normal_settle_time,
    MAX(settle_time) AS max_normal_settle_time
FROM bc_bet_records_213
WHERE settle_time < '2100-01-01 00:00:00';

SELECT settle_status, COUNT(*) AS row_count
FROM bc_bet_records_213
GROUP BY settle_status
ORDER BY settle_status;

SELECT category_id, COUNT(*) AS row_count
FROM bc_bet_records_213
GROUP BY category_id
ORDER BY category_id;

SELECT
    _tidb_rowid >> 59 AS rowid_shard,
    COUNT(*) AS row_count,
    MIN(_tidb_rowid & 576460752303423487) AS min_logical_rowid,
    MAX(_tidb_rowid & 576460752303423487) AS max_logical_rowid
FROM bc_bet_records_213
GROUP BY rowid_shard
ORDER BY rowid_shard;

SELECT COUNT(*) AS benchmark_query_matches
FROM bc_bet_records_213
WHERE category_id = 5
  AND settle_status = 2
  AND settle_time >= '2026-07-14 21:00:00'
  AND settle_time <= '2026-07-15 23:59:59'
  AND site_code = '213'
  AND currency = 'CNY';
