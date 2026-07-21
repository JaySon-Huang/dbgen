TiDB root@10.2.12.79:test> SET time_zone = '+00:00';
Query OK, 0 rows affected
Time: 0.047s
TiDB root@10.2.12.79:test> SET @correctness_engine='tikv'
Query OK, 0 rows affected
Time: 0.046s
TiDB root@10.2.12.79:test> SET @correctness_engine = COALESCE(@correctness_engine, 'tiflash');
                       ->  SET SESSION tidb_isolation_read_engines = @correctness_engine;
                       ->  SET SESSION tidb_allow_mpp = (@correctness_engine = 'tiflash');
                       ->  SET SESSION tidb_enforce_mpp = (@correctness_engine = 'tiflash');
Query OK, 0 rows affected
Time: 0.050s

Query OK, 0 rows affected
Time: 0.052s

Query OK, 0 rows affected
Time: 0.047s

Query OK, 0 rows affected
Time: 0.047s
TiDB root@10.2.12.79:test> select @@tidb_isolation_read_engines;
+-------------------------------+
| @@tidb_isolation_read_engines |
+-------------------------------+
| tikv                          |
+-------------------------------+

1 row in set
Time: 0.049s
TiDB root@10.2.12.79:test> select @@tidb_allow_mpp;
+------------------+
| @@tidb_allow_mpp |
+------------------+
|                0 |
+------------------+

1 row in set
Time: 0.049s
TiDB root@10.2.12.79:test> select @@tidb_enforce_mpp;
+--------------------+
| @@tidb_enforce_mpp |
+--------------------+
|                  0 |
+--------------------+

TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q01_target_27h' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.category_id = 5
                       ->    AND b.settle_status = 2
                       ->    AND b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
                       ->    AND b.site_code = '213'
                       ->    AND b.currency = 'CNY';
+----------------+-----------+-----------------+
| case_name      | row_count |    row_checksum |
+----------------+-----------+-----------------+
| Q01_target_27h |   1561136 | 775692823239671 |
+----------------+-----------+-----------------+
1 row in set
Time: 69.303s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q02_target_3h' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.category_id = 5
                       ->    AND b.settle_status = 2
                       ->    AND b.settle_time BETWEEN '2026-07-15 21:00:00' AND '2026-07-15 23:59:59'
                       ->    AND b.site_code = '213'
                       ->    AND b.currency = 'CNY';
+---------------+-----------+----------------+
| case_name     | row_count |   row_checksum |
+---------------+-----------+----------------+
| Q02_target_3h |    173647 | 86763277315052 |
+---------------+-----------+----------------+
1 row in set
Time: 68.883s
TiDB root@10.2.12.79:test> -- Expected Q03: 8240, 8102520948.
                       ->  SELECT /*+ ignore_plan_cache() */
                       ->      'Q03_target_3d' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.category_id = 5
                       ->    AND b.settle_status = 2
                       ->    AND b.settle_time BETWEEN '2026-07-13 00:00:00' AND '2026-07-15 23:59:59'
                       ->    AND b.site_code = '213'
                       ->    AND b.currency = 'CNY';
+---------------+-----------+------------------+
| case_name     | row_count |     row_checksum |
+---------------+-----------+------------------+
| Q03_target_3d |   4164543 | 2047562491651402 |
+---------------+-----------+------------------+
1 row in set
Time: 68.584s
TiDB root@10.2.12.79:test> -- Expected Q04: 83094, 69237508479.
                       ->  SELECT /*+ ignore_plan_cache() */
                       ->      'Q04_target_30d' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.category_id = 5
                       ->    AND b.settle_status = 2
                       ->    AND b.settle_time BETWEEN '2026-06-16 00:00:00' AND '2026-07-15 23:59:59'
                       ->    AND b.site_code = '213'
                       ->    AND b.currency = 'CNY';
+----------------+-----------+-------------------+
| case_name      | row_count |      row_checksum |
+----------------+-----------+-------------------+
| Q04_target_30d |  41629884 | 17345917947854190 |
+----------------+-----------+-------------------+
1 row in set
Time: 69.648s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q05_datetime_outside' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time = '2100-01-01 00:00:00';
+----------------------+-----------+----------------+
| case_name            | row_count |   row_checksum |
+----------------------+-----------+----------------+
| Q05_datetime_outside |     49748 | 12436870022534 |
+----------------------+-----------+----------------+
1 row in set
Time: 63.795s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q06_mixed_or_inside_first' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
                       ->     OR b.settle_time = '2100-01-01 00:00:00';
+---------------------------+-----------+------------------+
| case_name                 | row_count |     row_checksum |
+---------------------------+-----------+------------------+
| Q06_mixed_or_inside_first |   6299025 | 3117546528755788 |
+---------------------------+-----------+------------------+
1 row in set
Time: 68.656s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q07_mixed_or_outside_first' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time = '2100-01-01 00:00:00'
                       ->     OR b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59';
+----------------------------+-----------+------------------+
| case_name                  | row_count |     row_checksum |
+----------------------------+-----------+------------------+
| Q07_mixed_or_outside_first |   6299025 | 3117546528755788 |
+----------------------------+-----------+------------------+
1 row in set
Time: 68.911s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q08_date_inside' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_date BETWEEN '2026-07-14' AND '2026-07-15';
+-----------------+-----------+------------------+
| case_name       | row_count |     row_checksum |
+-----------------+-----------+------------------+
| Q08_date_inside |  11109920 | 5493238388822153 |
+-----------------+-----------+------------------+
1 row in set
Time: 64.852s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q09_date_outside' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_date = '2100-01-01';
+------------------+-----------+----------------+
| case_name        | row_count |   row_checksum |
+------------------+-----------+----------------+
| Q09_date_outside |     49748 | 12436870022534 |
+------------------+-----------+----------------+
1 row in set
Time: 65.755s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q10_null_bound' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time > NULL;
+----------------+-----------+--------------+
| case_name      | row_count | row_checksum |
+----------------+-----------+--------------+
| Q10_null_bound |         0 |            0 |
+----------------+-----------+--------------+
1 row in set
Time: 0.067s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q11_mixed_in' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time IN ('2026-07-14 21:00:00', '2100-01-01 00:00:00');
+--------------+-----------+----------------+
| case_name    | row_count |   row_checksum |
+--------------+-----------+----------------+
| Q11_mixed_in |     49812 | 12468470028646 |
+--------------+-----------+----------------+
1 row in set
Time: 0.474s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q12_equal_inside' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time = '2026-07-15 23:59:59';
+------------------+-----------+--------------+
| case_name        | row_count | row_checksum |
+------------------+-----------+--------------+
| Q12_equal_inside |         1 |    500000000 |
+------------------+-----------+--------------+
1 row in set
Time: 0.055s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q13_in_inside' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time IN ('2026-04-17 00:00:00', '2026-07-15 23:59:59');
+---------------+-----------+--------------+
| case_name     | row_count | row_checksum |
+---------------+-----------+--------------+
| Q13_in_inside |        66 |    500002145 |
+---------------+-----------+--------------+
1 row in set
Time: 0.061s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q14_lower_inclusive' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time >= '2026-07-15 23:59:59';
+---------------------+-----------+----------------+
| case_name           | row_count |   row_checksum |
+---------------------+-----------+----------------+
| Q14_lower_inclusive |     49749 | 12437370022534 |
+---------------------+-----------+----------------+
1 row in set
Time: 69.212s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q15_lower_exclusive' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time > '2026-07-15 23:59:59';
+---------------------+-----------+----------------+
| case_name           | row_count |   row_checksum |
+---------------------+-----------+----------------+
| Q15_lower_exclusive |     49748 | 12436870022534 |
+---------------------+-----------+----------------+
1 row in set
Time: 70.227s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q16_upper_inclusive' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time <= '2026-04-17 00:00:00';
+---------------------+-----------+--------------+
| case_name           | row_count | row_checksum |
+---------------------+-----------+--------------+
| Q16_upper_inclusive |        65 |         2145 |
+---------------------+-----------+--------------+
1 row in set
Time: 74.417s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q17_upper_exclusive' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time < '2026-04-17 00:00:00';
+---------------------+-----------+--------------+
| case_name           | row_count | row_checksum |
+---------------------+-----------+--------------+
| Q17_upper_exclusive |         0 |            0 |
+---------------------+-----------+--------------+
1 row in set
Time: 66.083s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q18_and_normal_order' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time >= '2026-07-14 21:00:00'
                       ->    AND b.settle_time <= '2026-07-15 23:59:59';
+----------------------+-----------+------------------+
| case_name            | row_count |     row_checksum |
+----------------------+-----------+------------------+
| Q18_and_normal_order |   6249277 | 3105109658733254 |
+----------------------+-----------+------------------+
1 row in set
Time: 66.737s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q19_and_reversed_order' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time <= '2026-07-15 23:59:59'
                       ->    AND b.settle_time >= '2026-07-14 21:00:00';
+------------------------+-----------+------------------+
| case_name              | row_count |     row_checksum |
+------------------------+-----------+------------------+
| Q19_and_reversed_order |   6249277 | 3105109658733254 |
+------------------------+-----------+------------------+
1 row in set
Time: 67.115s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q20_exclusive_range' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time > '2026-07-14 21:00:00'
                       ->    AND b.settle_time < '2026-07-15 23:59:59';
+---------------------+-----------+------------------+
| case_name           | row_count |     row_checksum |
+---------------------+-----------+------------------+
| Q20_exclusive_range |   6249212 | 3105077558727142 |
+---------------------+-----------+------------------+
1 row in set
Time: 66.430s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q21_upper_edge_inside' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time = '2099-11-30 23:59:59';
+-----------------------+-----------+--------------+
| case_name             | row_count | row_checksum |
+-----------------------+-----------+--------------+
| Q21_upper_edge_inside |         0 |            0 |
+-----------------------+-----------+--------------+
1 row in set
Time: 0.051s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q22_upper_edge_outside' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time = '2099-12-01 00:00:00';
+------------------------+-----------+--------------+
| case_name              | row_count | row_checksum |
+------------------------+-----------+--------------+
| Q22_upper_edge_outside |         0 |            0 |
+------------------------+-----------+--------------+
1 row in set
Time: 0.051s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q23_above_upper_edge' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time >= '2099-12-01 00:00:00';
+----------------------+-----------+----------------+
| case_name            | row_count |   row_checksum |
+----------------------+-----------+----------------+
| Q23_above_upper_edge |     49748 | 12436870022534 |
+----------------------+-----------+----------------+
1 row in set
Time: 66.615s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q24_not_equal' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time <> '2100-01-01 00:00:00';
+---------------+-----------+--------------------+
| case_name     | row_count |       row_checksum |
+---------------+-----------+--------------------+
| Q24_not_equal | 499950252 | 124987563379977466 |
+---------------+-----------+--------------------+
1 row in set
Time: 70.493s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q25_not_between' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE NOT (b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59');
+-----------------+-----------+--------------------+
| case_name       | row_count |       row_checksum |
+-----------------+-----------+--------------------+
| Q25_not_between | 493750723 | 121894890591266746 |
+-----------------+-----------+--------------------+
1 row in set
Time: 71.214s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q26_or_non_temporal' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
                       ->     OR b.settle_status = 1;
+---------------------+-----------+------------------+
| case_name           | row_count |     row_checksum |
+---------------------+-----------+------------------+
| Q26_or_non_temporal |   6299025 | 3117546528755788 |
+---------------------+-----------+------------------+
1 row in set
Time: 69.865s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q27_or_is_null' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
                       ->     OR b.settle_time IS NULL;
+----------------+-----------+------------------+
| case_name      | row_count |     row_checksum |
+----------------+-----------+------------------+
| Q27_or_is_null |   6249277 | 3105109658733254 |
+----------------+-----------+------------------+
1 row in set
Time: 67.742s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q28_cast_fallback' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE CAST(b.settle_time AS DATE) = '2026-07-15';
+-------------------+-----------+------------------+
| case_name         | row_count |     row_checksum |
+-------------------+-----------+------------------+
| Q28_cast_fallback |   5554901 | 2762020361328129 |
+-------------------+-----------+------------------+
1 row in set
Time: 67.504s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q29_in_with_null' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time IN ('2026-07-15 23:59:59', '2100-01-01 00:00:00', NULL);
+------------------+-----------+----------------+
| case_name        | row_count |   row_checksum |
+------------------+-----------+----------------+
| Q29_in_with_null |     49749 | 12437370022534 |
+------------------+-----------+----------------+
1 row in set
Time: 0.316s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q30_not_in_with_null' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time NOT IN ('2026-07-15 23:59:59', '2100-01-01 00:00:00', NULL);
+----------------------+-----------+--------------+
| case_name            | row_count | row_checksum |
+----------------------+-----------+--------------+
| Q30_not_in_with_null |         0 |            0 |
+----------------------+-----------+--------------+
1 row in set
Time: 0.050s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q31_mixed_tree' AS case_name,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time >= '2026-07-14 21:00:00'
                       ->    AND b.settle_time <= '2026-07-15 23:59:59'
                       ->    AND (b.settle_time = '2026-07-15 23:59:59'
                       ->         OR b.settle_time = '2100-01-01 00:00:00');
+----------------+-----------+--------------+
| case_name      | row_count | row_checksum |
+----------------+-----------+--------------+
| Q31_mixed_tree |         1 |    500000000 |
+----------------+-----------+--------------+
1 row in set
Time: 0.060s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q32_group_recent' AS case_name,
                       ->      b.settle_status,
                       ->      COUNT(*) AS row_count,
                       ->      COALESCE(SUM(b.id - 7000000000000000000), 0) AS row_checksum
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
                       ->  GROUP BY b.settle_status
                       ->  ORDER BY b.settle_status;
+------------------+---------------+-----------+------------------+
| case_name        | settle_status | row_count |     row_checksum |
+------------------+---------------+-----------+------------------+
| Q32_group_recent |             2 |   6243076 | 3102028870556078 |
| Q32_group_recent |             3 |      6201 |    3080788177176 |
+------------------+---------------+-----------+------------------+
2 rows in set
Time: 68.264s
TiDB root@10.2.12.79:test> SELECT /*+ ignore_plan_cache() */
                       ->      'Q33_topn_limit' AS case_name,
                       ->      b.id,
                       ->      b.record_id,
                       ->      b.order_no,
                       ->      b.category_id,
                       ->      b.settle_time,
                       ->      b.settle_status,
                       ->      b.settle_date
                       ->  FROM test.bc_bet_records_500m AS b
                       ->  WHERE b.category_id = 5
                       ->    AND b.settle_status = 2
                       ->    AND b.settle_time BETWEEN '2026-07-14 21:00:00' AND '2026-07-15 23:59:59'
                       ->    AND b.site_code = '213'
                       ->    AND b.currency = 'CNY'
                       ->  ORDER BY b.settle_time DESC, b.id DESC
                       ->  LIMIT 100;
+----------------+---------------------+---------------+---------------+-------------+---------------------+---------------+-------------+
| case_name      |                  id | record_id     | order_no      | category_id | settle_time         | settle_status | settle_date |
+----------------+---------------------+---------------+---------------+-------------+---------------------+---------------+-------------+
| Q33_topn_limit | 7000000000500000000 | rec-500000000 | ord-500000000 |           5 | 2026-07-15 23:59:59 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999995 | rec-499999995 | ord-499999995 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999994 | rec-499999994 | ord-499999994 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999992 | rec-499999992 | ord-499999992 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999987 | rec-499999987 | ord-499999987 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999986 | rec-499999986 | ord-499999986 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999981 | rec-499999981 | ord-499999981 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999977 | rec-499999977 | ord-499999977 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999971 | rec-499999971 | ord-499999971 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999967 | rec-499999967 | ord-499999967 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999964 | rec-499999964 | ord-499999964 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999954 | rec-499999954 | ord-499999954 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999951 | rec-499999951 | ord-499999951 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999950 | rec-499999950 | ord-499999950 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999947 | rec-499999947 | ord-499999947 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999939 | rec-499999939 | ord-499999939 |           5 | 2026-07-15 23:59:58 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999928 | rec-499999928 | ord-499999928 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999919 | rec-499999919 | ord-499999919 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999918 | rec-499999918 | ord-499999918 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999909 | rec-499999909 | ord-499999909 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999908 | rec-499999908 | ord-499999908 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999907 | rec-499999907 | ord-499999907 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999903 | rec-499999903 | ord-499999903 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999902 | rec-499999902 | ord-499999902 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999898 | rec-499999898 | ord-499999898 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999897 | rec-499999897 | ord-499999897 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999896 | rec-499999896 | ord-499999896 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999892 | rec-499999892 | ord-499999892 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999888 | rec-499999888 | ord-499999888 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999884 | rec-499999884 | ord-499999884 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999882 | rec-499999882 | ord-499999882 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999880 | rec-499999880 | ord-499999880 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999874 | rec-499999874 | ord-499999874 |           5 | 2026-07-15 23:59:57 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999866 | rec-499999866 | ord-499999866 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999857 | rec-499999857 | ord-499999857 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999856 | rec-499999856 | ord-499999856 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999855 | rec-499999855 | ord-499999855 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999853 | rec-499999853 | ord-499999853 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999849 | rec-499999849 | ord-499999849 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999841 | rec-499999841 | ord-499999841 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999840 | rec-499999840 | ord-499999840 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999839 | rec-499999839 | ord-499999839 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999830 | rec-499999830 | ord-499999830 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999827 | rec-499999827 | ord-499999827 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999826 | rec-499999826 | ord-499999826 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999823 | rec-499999823 | ord-499999823 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999814 | rec-499999814 | ord-499999814 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999812 | rec-499999812 | ord-499999812 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999810 | rec-499999810 | ord-499999810 |           5 | 2026-07-15 23:59:56 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999805 | rec-499999805 | ord-499999805 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999804 | rec-499999804 | ord-499999804 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999798 | rec-499999798 | ord-499999798 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999796 | rec-499999796 | ord-499999796 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999793 | rec-499999793 | ord-499999793 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999789 | rec-499999789 | ord-499999789 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999787 | rec-499999787 | ord-499999787 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999785 | rec-499999785 | ord-499999785 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999780 | rec-499999780 | ord-499999780 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999777 | rec-499999777 | ord-499999777 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999773 | rec-499999773 | ord-499999773 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999764 | rec-499999764 | ord-499999764 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999759 | rec-499999759 | ord-499999759 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999756 | rec-499999756 | ord-499999756 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999749 | rec-499999749 | ord-499999749 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999747 | rec-499999747 | ord-499999747 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999743 | rec-499999743 | ord-499999743 |           5 | 2026-07-15 23:59:55 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999741 | rec-499999741 | ord-499999741 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999739 | rec-499999739 | ord-499999739 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999736 | rec-499999736 | ord-499999736 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999735 | rec-499999735 | ord-499999735 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999732 | rec-499999732 | ord-499999732 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999731 | rec-499999731 | ord-499999731 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999727 | rec-499999727 | ord-499999727 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999724 | rec-499999724 | ord-499999724 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999710 | rec-499999710 | ord-499999710 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999708 | rec-499999708 | ord-499999708 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999705 | rec-499999705 | ord-499999705 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999704 | rec-499999704 | ord-499999704 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999702 | rec-499999702 | ord-499999702 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999699 | rec-499999699 | ord-499999699 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999696 | rec-499999696 | ord-499999696 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999694 | rec-499999694 | ord-499999694 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999690 | rec-499999690 | ord-499999690 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999688 | rec-499999688 | ord-499999688 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999685 | rec-499999685 | ord-499999685 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999679 | rec-499999679 | ord-499999679 |           5 | 2026-07-15 23:59:54 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999678 | rec-499999678 | ord-499999678 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999672 | rec-499999672 | ord-499999672 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999670 | rec-499999670 | ord-499999670 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999665 | rec-499999665 | ord-499999665 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999662 | rec-499999662 | ord-499999662 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999656 | rec-499999656 | ord-499999656 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999654 | rec-499999654 | ord-499999654 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999651 | rec-499999651 | ord-499999651 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999637 | rec-499999637 | ord-499999637 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999634 | rec-499999634 | ord-499999634 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999631 | rec-499999631 | ord-499999631 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999625 | rec-499999625 | ord-499999625 |           5 | 2026-07-15 23:59:53 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999611 | rec-499999611 | ord-499999611 |           5 | 2026-07-15 23:59:52 |             2 | 2026-07-15  |
| Q33_topn_limit | 7000000000499999605 | rec-499999605 | ord-499999605 |           5 | 2026-07-15 23:59:52 |             2 | 2026-07-15  |
+----------------+---------------------+---------------+---------------+-------------+---------------------+---------------+-------------+
100 rows in set
Time: 11.137s
TiDB root@10.2.12.79:test>


