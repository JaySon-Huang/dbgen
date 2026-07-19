-- 1. Execute the generated bc_bet_records_213-schema.sql first.
-- 2. Make sure trim min-max writing is enabled on TiFlash before creating the
--    TiFlash replica, so newly replicated stable DMFiles contain the index.
-- 3. Replace the URI below with the generated CSV location.

IMPORT INTO bc_bet_records_213
FROM 's3://<bucket>/<prefix>/bc_bet_records_213*.csv.gz'
FORMAT 'csv'
WITH thread = 16, detached;

-- For files on the TiDB server disk, use an absolute path instead:
-- IMPORT INTO bc_bet_records_213
-- FROM '/absolute/path/to/out/500m/bc_bet_records_213*.csv.gz'
-- FORMAT 'csv'
-- WITH thread = 16, detached;

-- After IMPORT INTO succeeds:
-- ALTER TABLE bc_bet_records_213 SET TIFLASH REPLICA 1;
-- ANALYZE TABLE bc_bet_records_213;
