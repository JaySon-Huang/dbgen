# Trim Min-Max Benchmark：Trim Read On 与 A/B 对比

## 1. 结论

本文记录重新执行的 B 轮。两个 TiFlash 实例均已确认加载：

```toml
dt_enable_trim_minmax_write = true
dt_enable_trim_minmax_read = true
```

结论如下：

1. P01–P04、P06 的 `pushdown.rs_operator` 将两个普通时间边界合并为一个 trim 专用 `date_range`；
2. 在 pack/segment 结构完全一致的 P01–P03 中，`rs_pack_filter_some` 分别下降 74.1%、75.3%、69.8%，LM scanned rows 分别下降 75.1%、76.1%、70.4%；
3. P01–P03 的 query read bytes 分别下降 45.3%、41.9%、34.9%，证明额外 pack pruning 转化成了实际读取量下降；
4. P05 的时间值位于有效日期范围外，ON/OFF 的 pushdown 都保持普通 `equal`，没有出现 `date_range`，符合回退普通 min-max 的设计；
5. P04–P06 两轮看到的 segment/read-task 数不同，绝对扫描量和耗时存在 DMFile 结构变化这一混杂因素，不能作为严格的单变量比较；
6. 即使 ON 轮 P06 面对更多 pack，`some` 仍从 83 降至 19，LM scanned rows 从 672,320 降至 148,032，trim pruning 的方向仍然明确。

此前 22:50–22:51 执行的旧 B 轮发生在确认两个实例热加载之前，已由本文和新原始日志替代。

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
| 正式轮完成时间 | 2026-07-15 23:26:21（Asia/Shanghai） |

配置热加载证据：

| 实例 | 日志时间 | 记录 |
| --- | --- | --- |
| 9522 | 2026-07-15 23:25:33.027 +08:00 | `old: 0, new: true` |
| 9523 | 2026-07-15 23:25:34.191 +08:00 | `old: 0, new: true` |

执行方法与 A 轮一致：确认热加载后执行一次预热，再执行一次正式轮；正式轮的每个查询使用独立事务和 TSO，并从两个 TiFlash 实例收集原始 MPP task 日志。

## 3. Pushdown 变化

### 3.1 Trim read off

P01–P04、P06 的时间范围是两个普通 rough-set 条件：

```json
{"col":"settle_time","op":"greater_equal","value":"<lower>"}
{"col":"settle_time","op":"less_equal","value":"<upper>"}
```

### 3.2 Trim read on

同一范围被归一化为一个 `date_range`：

```json
{
  "class": "EqualityOrInOrBounded",
  "col": "settle_time",
  "lower": "<lower>",
  "op": "date_range",
  "upper": "<upper>"
}
```

lower/upper 的编码值在 A/B 两轮完全相同。`category_id`、`settle_status` 和两个字符串 unsupported 节点也保持不变。因此 `date_range` 结构和随后的 pruning 差异可以归因于 trim read 路径。

P05 在两轮中均为：

```json
{"col":"settle_time","op":"equal","value":"1921139283817660416"}
```

该值对应 `2100-01-01 00:00:00`，位于 trim 有效日期范围外，未选择 `date_range`。

## 4. B 轮查询结果

| Query | 场景 | TSO | Root time | RU | TableScan actRows |
| --- | --- | --- | ---: | ---: | ---: |
| P01 | 3 小时聚合 | `467698758694469633` | 17.3 ms | 101.41 | 1,389 |
| P02 | 27 小时聚合 | `467698758760005633` | 15.6 ms | 104.28 | 12,500 |
| P03 | 3 天聚合 | `467698758812434433` | 21.0 ms | 134.43 | 33,333 |
| P04 | 30 天聚合 | `467698758864863233` | 25.2 ms | 112.62 | 114,852 |
| P05 | 有效范围外等值条件 | `467698758930399233` | 13.3 ms | 84.12 | 588,378 |
| P06 | 原始业务形态查询 | `467698758983090178` | 85.8 ms | 759.80 | 12,500 |

`TableScan actRows` 是当前物理计划中 TableFullScan 节点的输出，不是最终 SQL 结果行数；过滤条件在 TableScan/Selection 之间的放置可能使该数字发生变化。

## 5. Pack-filter A/B 对比

| Query | OFF none / some / total | ON none / some / total | `some` 变化 | Segment/read task OFF → ON |
| --- | ---: | ---: | ---: | ---: |
| P01 | 149 / 81 / 230 | 209 / 21 / 230 | -74.1% | 2/2 → 2/2 |
| P02 | 145 / 85 / 230 | 209 / 21 / 230 | -75.3% | 2/2 → 2/2 |
| P03 | 160 / 86 / 246 | 220 / 26 / 246 | -69.8% | 3/3 → 3/3 |
| P04 | 143 / 103 / 246 | 171 / 59 / 230 | -42.7% | 3/3 → 2/2 |
| P05 | 160 / 70 / 230 | 174 / 72 / 246 | +2.9% | 2/2 → 3/3 |
| P06 | 147 / 83 / 230 | 227 / 19 / 246 | -77.1% | 2/2 → 3/3 |

两轮所有查询的 `rs_pack_filter_all`、`rs_pack_filter_all_null`、`rs_dmfile_read_with_all` 都为 0。

P01–P03 的 pack total 和 segment/read-task 数一致，是最干净的单变量证据：开启 trim 后分别有 60、64、60 个 pack 从 `some` 转成 `none`。

## 6. Scan details A/B 对比

### 6.1 主要扫描和读取指标

箭头方向为 OFF → ON。

| Query | LM scanned | Data scanned | Query read bytes | DMFile read time（task 累计） |
| --- | ---: | ---: | ---: | ---: |
| P01 | 654,490 → 162,970（-75.1%） | 171,162 → 122,010（-28.7%） | 9,811,818 → 5,371,050（-45.3%） | 18.690 → 13.576 ms（-27.4%） |
| P02 | 687,258 → 164,416（-76.1%） | 179,354 → 139,840（-22.0%） | 10,245,770 → 5,954,624（-41.9%） | 20.802 → 13.257 ms（-36.3%） |
| P03 | 698,342 → 206,822（-70.4%） | 215,014 → 165,862（-22.9%） | 11,007,478 → 7,168,982（-34.9%） | 23.493 → 18.412 ms（-21.6%） |
| P04 | 836,160 → 475,712（-43.1%） | 836,160 → 475,712（-43.1%） | 14,254,312 → 6,649,097（-53.4%） | 40.889 → 24.888 ms（-39.1%） |
| P05 | 0 → 0 | 573,440 → 589,824（+2.9%） | 5,160,960 → 5,308,416（+2.9%） | 8.549 → 10.168 ms（+18.9%） |
| P06 | 672,320 → 148,032（-78.0%） | 188,992 → 131,648（-30.3%） | 55,599,267 → 49,018,429（-11.8%） | 139.590 → 139.105 ms（-0.3%） |

### 6.2 Skipped、MVCC 和 late materialization

| Query | LM skipped OFF → ON | Data skipped OFF → ON | MVCC scanned OFF → ON | Late-materialization skipped OFF → ON |
| --- | ---: | ---: | ---: | ---: |
| P01 | 1,220,608 → 1,712,128 | 1,703,936 → 1,753,088 | 40,960 → 73,728 | 270,336 → 40,960 |
| P02 | 1,187,840 → 1,710,682 | 1,695,744 → 1,490,944 | 73,728 → 49,152 | 278,528 → 24,576 |
| P03 | 1,301,658 → 1,793,178 | 1,540,096 → 1,589,248 | 73,728 → 90,112 | 245,760 → 40,960 |
| P04 | 1,163,840 → 1,399,386 | 917,504 → 1,155,072 | 81,920 → 32,768 | 0 → 0 |
| P05 | 0 → 0 | 1,301,658 → 1,410,176 | 0 → 8,192 | 0 → 0 |
| P06 | 1,202,778 → 1,851,968 | 1,441,792 → 1,622,016 | 49,152 → 32,768 | 286,720 → 16,384 |

`late_materialization_skip_rows` 大幅下降不是退化：trim min-max 在更早的 pack-filter 阶段排除了更多 pack，留给 late materialization 再过滤的行自然减少。

P01/P03 的 MVCC scanned rows 在 ON 轮增加，但 query read bytes、LM scanned 和 data scanned 同时显著下降。这反映两次 snapshot/read-task 的具体划分差异，不能单独用 MVCC scanned 判断 trim 效果。

## 7. 执行成本 A/B 对比

| Query | Root time OFF → ON | RU OFF → ON | `rs_pack_filter_check_time` OFF → ON |
| --- | ---: | ---: | ---: |
| P01 | 21.8 → 17.3 ms（-20.6%） | 161.01 → 101.41（-37.0%） | 0.533 → 0.537 ms |
| P02 | 21.2 → 15.6 ms（-26.4%） | 177.46 → 104.28（-41.2%） | 0.635 → 0.474 ms |
| P03 | 22.2 → 21.0 ms（-5.4%） | 190.42 → 134.43（-29.4%） | 0.641 → 0.744 ms |
| P04 | 34.6 → 25.2 ms（-27.2%） | 241.42 → 112.62（-53.4%） | 0.675 → 0.470 ms |
| P05 | 10.8 → 13.3 ms（+23.1%） | 80.75 → 84.12（+4.2%） | 0.187 → 0.297 ms |
| P06 | 94.9 → 85.8 ms（-9.6%） | 868.46 → 759.80（-12.5%） | 0.488 → 0.724 ms |

`rs_pack_filter_check_time` 始终小于 1 ms；trim range 归一化和 pack 检查没有形成明显额外开销。Root time 是单次正式轮结果，需要更多重复轮次才能形成稳定的延迟结论；扫描量和 pack 状态的变化更具解释力。

## 8. 控制变量与限制

- P01、P02、P03 的 pack total、segment、read-task 数在 A/B 两轮一致，可用于严格比较；
- P04、P05、P06 的 segment/read-task 数发生变化，说明不同 TSO 读取到的 DMFile/segment 结构不同，其绝对扫描量和耗时包含额外变量；
- P05 的 pushdown 在 ON/OFF 完全相同且不包含 `date_range`，支持有效范围外回退正确；
- P06 的 ON 轮 pack total 更多，但 `some` 和 LM scanned 仍显著下降，因此 trim pruning 的方向可信，精确收益比例则需要冻结 DMFile 结构后复测；
- 本轮只有一次预热和一次正式测量，不应把单次 root time 当作稳定 P50/P95。

## 9. 原始数据

- [完整 SQL 输出](results/2026-07-15/trim-read-on/benchmark-output.tsv)
- [结构化汇总](results/2026-07-15/trim-read-on/summary.json)
- [完整 A/B 机器可读对比](results/2026-07-15/comparison.json)
- [P01 MPP 原始日志](results/2026-07-15/trim-read-on/P01_3h.tso-467698758694469633.mpp.log)
- [P02 MPP 原始日志](results/2026-07-15/trim-read-on/P02_27h.tso-467698758760005633.mpp.log)
- [P03 MPP 原始日志](results/2026-07-15/trim-read-on/P03_3d.tso-467698758812434433.mpp.log)
- [P04 MPP 原始日志](results/2026-07-15/trim-read-on/P04_30d.tso-467698758864863233.mpp.log)
- [P05 MPP 原始日志](results/2026-07-15/trim-read-on/P05_outside.tso-467698758930399233.mpp.log)
- [P06 MPP 原始日志](results/2026-07-15/trim-read-on/P06_production.tso-467698758983090178.mpp.log)

每个 `.mpp.log` 文件保留该 TSO 在两个 TiFlash 日志中匹配到的全部 `MPPTaskStatistics.cpp` 原始行。本轮每个文件各有两条 `[INFO]`/`FINISHED` 记录，分别来自 9522 和 9523，并按 query TSO 汇总两个 task。

实验结束后，两个 TiFlash 实例均保持 `dt_enable_trim_minmax_read=true`。
