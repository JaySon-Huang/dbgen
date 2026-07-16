# Trim Min-Max 500m Benchmark：Trim Read Off 基线

## 1. 结论

本文记录 `test.bc_bet_records_500m` 的 A 轮基线。两个 TiFlash 实例均已确认加载：

```toml
dt_enable_trim_minmax_write = true
dt_enable_trim_minmax_read = false
```

每个 P01–P06 查询使用独立事务和 TSO。本轮保存了完整 `EXPLAIN ANALYZE` 输出、两个 TiFlash 实例的原始 `MPPTaskStatistics.cpp` 日志，以及从最终 `[INFO]` 记录解析出的 `scan_details`。

OFF 状态下，P01–P04、P06 的时间范围在 `pushdown.rs_operator` 中表现为两个普通条件：

```json
{"col":"settle_time","op":"greater_equal","value":"<lower>"}
{"col":"settle_time","op":"less_equal","value":"<upper>"}
```

由于 `2100-01-01` 哨兵值均匀分布，窄时间范围仍有约 47%–51% 的 pack 被判断为 `some`。P01–P03 的 LM scanned rows 达到约 2.78–2.85 亿行，构成 trim min-max 的主要优化空间。

## 2. 环境和执行方法

| 项目 | 值 |
| --- | --- |
| TiDB | `10.2.12.79:8020` |
| Table | `test.bc_bet_records_500m` |
| 数据量 | 500,000,000 行 |
| TiFlash | `10.2.12.81:9522`、`10.2.12.81:9523` |
| TiFlash replica | 2，AVAILABLE=1，PROGRESS=1.0 |
| 表统计信息 | 已 ANALYZE |
| Session time zone | `+00:00` |
| MPP | `tidb_allow_mpp=1`、`tidb_enforce_mpp=1` |
| 正式轮完成时间 | 2026-07-16 09:33:22（Asia/Shanghai） |

配置热加载证据：

| 实例 | 日志时间 | 记录 |
| --- | --- | --- |
| 9522 | 2026-07-16 09:32:28.259 +08:00 | `old: 1, new: false` |
| 9523 | 2026-07-16 09:32:29.411 +08:00 | `old: 1, new: false` |

执行顺序：确认两个实例加载 false，完整预热一次，然后正式执行一次 500m benchmark，并立即按 TSO 收集日志。本文中的 root time 是单次正式轮结果；pack-filter 和扫描计数是主要分析依据。

## 3. 查询和 TSO

| Query | 场景 | TSO | Root time | RU | TableScan actRows |
| --- | --- | --- | ---: | ---: | ---: |
| P01 | 3 小时聚合 | `467708305834770434` | 156.1 ms | 38,651.35 | 694,314 |
| P02 | 27 小时聚合 | `467708305913413634` | 156.2 ms | 41,942.15 | 6,249,277 |
| P03 | 3 天聚合 | `467708306005426177` | 167.7 ms | 47,828.49 | 16,664,917 |
| P04 | 30 天聚合 | `467708306096914434` | 559.4 ms | 106,394.72 | 88,233,540 |
| P05 | 有效范围外等值条件 | `467708306293784577` | 106.5 ms | 39,042.68 | 277,976,313 |
| P06 | 原始业务形态查询 | `467708306359058434` | 405.0 ms | 77,147.58 | 6,249,277 |

`TableScan actRows` 是当前物理计划 TableFullScan 节点的输出，不是最终 SQL 返回行数。P01–P04 聚合最终计数已经在 correctness 中验证，P06 最终返回 100 行。

## 4. Pack-filter 基线

下表汇总两个 TiFlash task。`some rate` 使用 `some / (none + some + all + all_null)` 计算。

| Query | `none` | `some` | Pack total | `some rate` | Segment / read task | Local regions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| P01 | 38,502 | 34,047 | 72,549 | 46.93% | 591 / 591 | 997 |
| P02 | 36,118 | 34,325 | 70,443 | 48.73% | 583 / 583 | 997 |
| P03 | 34,204 | 34,919 | 69,123 | 50.52% | 583 / 583 | 997 |
| P04 | 28,871 | 43,251 | 72,122 | 59.97% | 590 / 590 | 997 |
| P05 | 36,458 | 34,003 | 70,461 | 48.26% | 586 / 586 | 997 |
| P06 | 37,160 | 34,343 | 71,503 | 48.03% | 588 / 588 | 997 |

所有查询的 `rs_pack_filter_all`、`rs_pack_filter_all_null`、`rs_dmfile_read_with_all` 都为 0。

## 5. Scan details 基线

### 5.1 主要读取指标

| Query | LM scanned | LM skipped | Data scanned | Data skipped | Query read bytes |
| --- | ---: | ---: | ---: | ---: | ---: |
| P01 | 278,347,054 | 313,379,291 | 868,352 | 535,690,542 | 2,529,543,134 |
| P02 | 280,673,265 | 293,923,587 | 6,671,407 | 521,621,442 | 2,737,945,849 |
| P03 | 285,468,103 | 278,257,493 | 17,074,200 | 510,066,095 | 3,113,603,743 |
| P04 | 353,027,863 | 235,180,602 | 353,027,863 | 184,344,576 | 6,876,171,478 |
| P05 | 0 | 0 | 278,021,082 | 296,655,751 | 2,502,189,738 |
| P06 | 280,735,469 | 302,421,669 | 6,682,424 | 524,924,853 | 5,015,739,946 |

### 5.2 MVCC、late materialization 和时间

| Query | MVCC scanned | MVCC skipped | MVCC read bytes | LM late skipped | DMFile read time（task 累计） |
| --- | ---: | ---: | ---: | ---: | ---: |
| P01 | 147,456 | 66,729,949 | 2,506,752 | 277,216,558 | 4,216.099 ms |
| P02 | 114,688 | 55,343,309 | 1,949,696 | 273,690,562 | 3,948.624 ms |
| P03 | 131,072 | 59,723,244 | 2,228,224 | 268,017,071 | 4,209.904 ms |
| P04 | 196,608 | 89,441,265 | 3,342,336 | 0 | 19,080.245 ms |
| P05 | 106,496 | 47,655,151 | 1,810,432 | 0 | 3,070.442 ms |
| P06 | 139,264 | 62,704,502 | 2,367,488 | 273,790,901 | 6,142.631 ms |

P01–P03 和 P06 的 Data scanned 已经被 late materialization 大幅压低，但为完成 late materialization，系统仍然需要检查约 2.8 亿候选行。trim min-max 的价值主要体现在提前消除这些候选 pack。

其他共同属性：

- `read_mode=Bitmap`；
- 没有 remote region 和 stale read；
- `delta_rows=0`、`delta_bytes=0`；
- `mvcc_input_rows=0`、`mvcc_input_bytes=0`。

## 6. 原始产物

- [本轮实际执行的 500m SQL](results/2026-07-16/500m/benchmark.sql)
- [完整 SQL 输出](results/2026-07-16/500m/trim-read-off/benchmark-output.tsv)
- [结构化汇总](results/2026-07-16/500m/trim-read-off/summary.json)
- [P01 MPP 原始日志](results/2026-07-16/500m/trim-read-off/P01_3h.tso-467708305834770434.mpp.log)
- [P02 MPP 原始日志](results/2026-07-16/500m/trim-read-off/P02_27h.tso-467708305913413634.mpp.log)
- [P03 MPP 原始日志](results/2026-07-16/500m/trim-read-off/P03_3d.tso-467708306005426177.mpp.log)
- [P04 MPP 原始日志](results/2026-07-16/500m/trim-read-off/P04_30d.tso-467708306096914434.mpp.log)
- [P05 MPP 原始日志](results/2026-07-16/500m/trim-read-off/P05_outside.tso-467708306293784577.mpp.log)
- [P06 MPP 原始日志](results/2026-07-16/500m/trim-read-off/P06_production.tso-467708306359058434.mpp.log)

每个 `.mpp.log` 文件保留该 TSO 在 9522、9523 日志中匹配到的原始 `MPPTaskStatistics.cpp` 行；分析只使用 `[INFO]`/`FINISHED` 记录。
