# Trim Min-Max Benchmark：Trim Read Off 基线

## 1. 结论

本文记录重新执行的 A 轮基线。两个 TiFlash 实例均已确认加载：

```toml
dt_enable_trim_minmax_write = true
dt_enable_trim_minmax_read = false
```

本轮为每个 P01–P06 查询分配了独立事务和 TSO，并保存：

- `mycli` 的完整 `EXPLAIN ANALYZE` 输出；
- 两个 TiFlash 实例上按 TSO 过滤出的原始 `MPPTaskStatistics.cpp` 日志；
- 从最终 `[INFO]` 日志解析出的完整 `scan_details` 和汇总数据。

基线中的时间范围在 `pushdown.rs_operator` 中表现为两个普通 rough-set 条件：

```json
{"col":"settle_time","op":"greater_equal","value":"..."}
{"col":"settle_time","op":"less_equal","value":"..."}
```

本文替代此前没有 TSO 原始日志支持的旧版基线结果。

## 2. 执行环境和方法

| 项目 | 值 |
| --- | --- |
| TiDB | `10.2.12.79:8020` |
| Database / Table | `test.bc_bet_records_1m` |
| 数据量 | 1,000,000 行 |
| TiFlash | `10.2.12.81:9522`、`10.2.12.81:9523` |
| Session time zone | `+00:00` |
| MPP | `tidb_allow_mpp=1`、`tidb_enforce_mpp=1` |
| 表统计信息 | 已 ANALYZE |
| 正式轮完成时间 | 2026-07-15 23:25:10（Asia/Shanghai） |

配置热加载证据：

| 实例 | 日志时间 | 记录 |
| --- | --- | --- |
| 9522 | 2026-07-15 23:23:53.023 +08:00 | `old: 1, new: false` |
| 9523 | 2026-07-15 23:23:52.187 +08:00 | `old: 1, new: false` |

执行顺序：

1. 将两个实例的 `dt_enable_trim_minmax_read` 设置为 `false`；
2. 等待两个实例都出现新的 `reload delta tree` 日志；
3. 完整执行一次 `tiflash-benchmark.sql` 作为预热；
4. 再完整执行一次作为正式轮；
5. 对正式轮 P01–P06 的每个 TSO，立即收集 9522 和 9523 的 MPP 原始日志。

本文中的耗时来自一次正式轮，只用于与紧随其后的 ON 轮观察方向，不代表稳定性能分位数。pack-filter 和扫描计数是本轮的主要证据。

## 3. 查询、TSO 和执行结果

| Query | 场景 | TSO | Root time | RU | TableScan actRows |
| --- | --- | --- | ---: | ---: | ---: |
| P01 | 3 小时聚合 | `467698739951173634` | 21.8 ms | 161.01 | 1,389 |
| P02 | 27 小时聚合 | `467698740016709639` | 21.2 ms | 177.46 | 12,500 |
| P03 | 3 天聚合 | `467698740082245633` | 22.2 ms | 190.42 | 33,333 |
| P04 | 30 天聚合 | `467698740134674433` | 34.6 ms | 241.42 | 198,788 |
| P05 | 有效范围外等值条件 | `467698740252639234` | 10.8 ms | 80.75 | 573,440 |
| P06 | 原始业务形态查询 | `467698740318437377` | 94.9 ms | 868.46 | 12,500 |

P01–P04 和 P06 的结果通过其他过滤条件后分别对应既有测试数据分布；P05 命中 102 个 `2100-01-01` 哨兵值。完整算子输出保存在原始 SQL 文件中。

## 4. Rough-set pack filter 基线

下表是两个 TiFlash task 的加和：

| Query | `none` | `some` | `all` | `all_null` | Pack total | Segment / read task |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| P01 | 149 | 81 | 0 | 0 | 230 | 2 / 2 |
| P02 | 145 | 85 | 0 | 0 | 230 | 2 / 2 |
| P03 | 160 | 86 | 0 | 0 | 246 | 3 / 3 |
| P04 | 143 | 103 | 0 | 0 | 246 | 3 / 3 |
| P05 | 160 | 70 | 0 | 0 | 230 | 2 / 2 |
| P06 | 147 | 83 | 0 | 0 | 230 | 2 / 2 |

所有查询的 `rs_dmfile_read_with_all` 也均为 0。对 P01–P04、P06，普通 min-max 受到均匀分布的 `2100-01-01` 哨兵值影响，较多 pack 被判断为 `some`，需要进入后续读取阶段。

## 5. Scan details 基线

### 5.1 行数与读取量

| Query | LM scanned | LM skipped | Data scanned | Data skipped | MVCC scanned | MVCC skipped |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| P01 | 654,490 | 1,220,608 | 171,162 | 1,703,936 | 40,960 | 1,834,138 |
| P02 | 687,258 | 1,187,840 | 179,354 | 1,695,744 | 73,728 | 1,801,370 |
| P03 | 698,342 | 1,301,658 | 215,014 | 1,540,096 | 73,728 | 1,801,370 |
| P04 | 836,160 | 1,163,840 | 836,160 | 917,504 | 81,920 | 1,793,178 |
| P05 | 0 | 0 | 573,440 | 1,301,658 | 0 | 0 |
| P06 | 672,320 | 1,202,778 | 188,992 | 1,441,792 | 49,152 | 1,825,946 |

| Query | Query read bytes | MVCC read bytes | Late-materialization skipped | DMFile read time（task 累计） |
| --- | ---: | ---: | ---: | ---: |
| P01 | 9,811,818 | 696,320 | 270,336 | 18.690 ms |
| P02 | 10,245,770 | 1,253,376 | 278,528 | 20.802 ms |
| P03 | 11,007,478 | 1,253,376 | 245,760 | 23.493 ms |
| P04 | 14,254,312 | 1,392,640 | 0 | 40.889 ms |
| P05 | 5,160,960 | 0 | 0 | 8.549 ms |
| P06 | 55,599,267 | 835,584 | 286,720 | 139.590 ms |

### 5.2 其他字段

- 所有查询均为 `Bitmap` read mode；
- 每个 MPP task 的 `num_columns` 为 5；
- 每个查询包含 8 个 local regions，没有 remote regions；
- `delta_rows=0`、`delta_bytes=0`；
- `mvcc_input_rows=0`、`mvcc_input_bytes=0`、`mvcc_skip_rows=0`；
- 没有 stale read。

`rs_pack_filter_check_time` 的两个 task 累计值分别为：P01 0.533 ms、P02 0.635 ms、P03 0.641 ms、P04 0.675 ms、P05 0.187 ms、P06 0.488 ms。

## 6. 原始数据

- [完整 SQL 输出](results/2026-07-15/trim-read-off/benchmark-output.tsv)
- [结构化汇总](results/2026-07-15/trim-read-off/summary.json)
- [P01 MPP 原始日志](results/2026-07-15/trim-read-off/P01_3h.tso-467698739951173634.mpp.log)
- [P02 MPP 原始日志](results/2026-07-15/trim-read-off/P02_27h.tso-467698740016709639.mpp.log)
- [P03 MPP 原始日志](results/2026-07-15/trim-read-off/P03_3d.tso-467698740082245633.mpp.log)
- [P04 MPP 原始日志](results/2026-07-15/trim-read-off/P04_30d.tso-467698740134674433.mpp.log)
- [P05 MPP 原始日志](results/2026-07-15/trim-read-off/P05_outside.tso-467698740252639234.mpp.log)
- [P06 MPP 原始日志](results/2026-07-15/trim-read-off/P06_production.tso-467698740318437377.mpp.log)

每个 `.mpp.log` 文件保留该 TSO 在两个 TiFlash 日志中匹配到的全部 `MPPTaskStatistics.cpp` 原始行。本轮当前日志级别下，每个文件各有两条 `[INFO]`/`FINISHED` 记录，分别来自 9522 和 9523；没有产生或保留 `INITIALIZING` DEBUG 记录。
