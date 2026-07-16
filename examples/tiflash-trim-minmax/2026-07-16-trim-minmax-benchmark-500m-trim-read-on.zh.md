# Trim Min-Max 500m Benchmark：Trim Read On 与 A/B 对比

## 1. 结论

本文记录 `test.bc_bet_records_500m` 的 B 轮，以及与同日 OFF 基线的对比。两个 TiFlash 实例均已确认加载：

```toml
dt_enable_trim_minmax_write = true
dt_enable_trim_minmax_read = true
```

500m 数据上的效果非常明确：

- P01、P02、P03、P06 的 `rs_pack_filter_some` 分别下降 99.70%、97.67%、94.06%、97.67%；
- 对应 LM scanned rows 分别下降 99.70%、97.68%、94.07%、97.68%；
- query read bytes 分别下降 98.65%、90.24%、77.70%、50.02%；
- 单次正式轮 root time 分别下降 64.64%、58.19%、49.61%、36.91%；
- P04 的 30 天窗口仍获得约 52% 的 LM/data scanned 降幅；
- P05 位于有效范围外，ON/OFF pushdown 完全相同，pack 比例、读取量和 RU 基本不变，符合回退普通 min-max 的设计。

P01–P04、P06 的 `pushdown.rs_operator` 在 ON 轮都出现 `EqualityOrInOrBounded/date_range`，结合 pack-filter 变化，证明 trim min-max 路径已被实际选择。

## 2. 环境和执行方法

| 项目 | 值 |
| --- | --- |
| TiDB | `10.2.12.79:8020` |
| Table | `test.bc_bet_records_500m` |
| 数据量 | 500,000,000 行 |
| TiFlash | `10.2.12.81:9522`、`10.2.12.81:9523` |
| 表统计信息 | 已 ANALYZE |
| Session time zone | `+00:00` |
| MPP | `tidb_allow_mpp=1`、`tidb_enforce_mpp=1` |
| 正式轮完成时间 | 2026-07-16 09:34:29（Asia/Shanghai） |

配置热加载证据：

| 实例 | 日志时间 | 记录 |
| --- | --- | --- |
| 9522 | 2026-07-16 09:33:44.261 +08:00 | `old: 0, new: true` |
| 9523 | 2026-07-16 09:33:45.414 +08:00 | `old: 0, new: true` |

执行方法与 OFF 轮一致：确认双实例热加载后预热一次，再正式执行一次；每个查询使用独立事务和 TSO，并立即收集两个 TiFlash task 的原始日志。

## 3. Pushdown 差异

### 3.1 OFF

```json
{"col":"settle_time","op":"greater_equal","value":"<lower>"}
{"col":"settle_time","op":"less_equal","value":"<upper>"}
```

### 3.2 ON

```json
{
  "class": "EqualityOrInOrBounded",
  "col": "settle_time",
  "lower": "<lower>",
  "op": "date_range",
  "upper": "<upper>"
}
```

两轮 lower/upper 的编码值完全相同；`category_id`、`settle_status` 和两个字符串 unsupported 节点也保持一致。

P05 在两轮中均保持普通等值条件：

```json
{"col":"settle_time","op":"equal","value":"1921139283817660416"}
```

该值对应 `2100-01-01 00:00:00`，位于 trim 有效日期范围之外。

## 4. B 轮查询和 TSO

| Query | 场景 | TSO | Root time | RU | TableScan actRows |
| --- | --- | --- | ---: | ---: | ---: |
| P01 | 3 小时聚合 | `467708323726360584` | 55.2 ms | 527.84 | 694,314 |
| P02 | 27 小时聚合 | `467708323791634433` | 65.3 ms | 4,170.21 | 6,249,277 |
| P03 | 3 天聚合 | `467708323857170433` | 84.5 ms | 10,832.56 | 16,664,917 |
| P04 | 30 天聚合 | `467708323922706433` | 321.9 ms | 34,892.46 | 41,925,982 |
| P05 | 有效范围外等值条件 | `467708324053778433` | 119.5 ms | 39,074.67 | 278,511,854 |
| P06 | 原始业务形态查询 | `467708324132421633` | 255.5 ms | 38,812.54 | 6,249,277 |

`TableScan actRows` 不是最终 SQL 结果行数。P04 的部分过滤条件在 ON/OFF 物理算子之间放置不同，因此该节点的 actRows 也发生变化。

## 5. Pack-filter A/B 对比

| Query | OFF none / some / total | ON none / some / total | Some rate OFF → ON | Segment OFF → ON |
| --- | ---: | ---: | ---: | ---: |
| P01 | 38,502 / 34,047 / 72,549 | 69,437 / 102 / 69,539 | 46.93% → 0.15% | 591 → 585 |
| P02 | 36,118 / 34,325 / 70,443 | 70,029 / 801 / 70,830 | 48.73% → 1.13% | 583 → 586 |
| P03 | 34,204 / 34,919 / 69,123 | 67,764 / 2,075 / 69,839 | 50.52% → 2.97% | 583 → 585 |
| P04 | 28,871 / 43,251 / 72,122 | 49,442 / 20,583 / 70,025 | 59.97% → 29.39% | 590 → 587 |
| P05 | 36,458 / 34,003 / 70,461 | 36,585 / 34,070 / 70,655 | 48.26% → 48.22% | 586 → 588 |
| P06 | 37,160 / 34,343 / 71,503 | 71,022 / 800 / 71,822 | 48.03% → 1.11% | 588 → 587 |

两个 TSO 看到的 segment/pack total 有小幅变化，最大为 P01 的约 4.2%。使用 some rate 归一化后，trim 的差异仍远大于结构波动。所有查询都包含 997 个 local regions，没有 remote region。

两轮的 `rs_pack_filter_all`、`rs_pack_filter_all_null`、`rs_dmfile_read_with_all` 均为 0。

## 6. Scan details A/B 对比

### 6.1 LM、Data 和读取字节

箭头方向为 OFF → ON。

| Query | LM scanned | Data scanned | Query read bytes |
| --- | ---: | ---: | ---: |
| P01 | 278,347,054 → 830,401（-99.70%） | 868,352 → 830,401（-4.37%） | 2,529,543,134 → 34,046,441（-98.65%） |
| P02 | 280,673,265 → 6,519,829（-97.68%） | 6,671,407 → 6,519,829（-2.27%） | 2,737,945,849 → 267,312,989（-90.24%） |
| P03 | 285,468,103 → 16,932,634（-94.07%） | 17,074,200 → 16,932,634（-0.83%） | 3,113,603,743 → 694,237,994（-77.70%） |
| P04 | 353,027,863 → 167,741,033（-52.49%） | 353,027,863 → 167,741,033（-52.49%） | 6,876,171,478 → 2,237,287,130（-67.46%） |
| P05 | 0 → 0 | 278,021,082 → 278,580,531（+0.20%） | 2,502,189,738 → 2,507,224,779（+0.20%） |
| P06 | 280,735,469 → 6,521,179（-97.68%） | 6,682,424 → 6,521,179（-2.41%） | 5,015,739,946 → 2,506,918,493（-50.02%） |

P01–P03、P06 中，OFF 轮依赖 late materialization 从约 2.8 亿候选行中筛出最终数据；ON 轮在 pack-filter 阶段已经去掉绝大部分候选 pack，所以 LM scanned 和 query read bytes 大幅下降，而最终 Data scanned 接近查询真实时间窗口的规模。

### 6.2 Skipped 和 MVCC

| Query | LM skipped OFF → ON | Data skipped OFF → ON | MVCC scanned OFF → ON | Late-materialization skipped OFF → ON |
| --- | ---: | ---: | ---: | ---: |
| P01 | 313,379,291 → 566,261,163 | 535,690,542 → 22,118,400 | 147,456 → 0 | 277,216,558 → 0 |
| P02 | 293,923,587 → 571,245,238 | 521,621,442 → 19,701,760 | 114,688 → 0 | 273,690,562 → 0 |
| P03 | 278,257,493 → 552,715,020 | 510,066,095 → 21,430,272 | 131,072 → 0 | 268,017,071 → 0 |
| P04 | 235,180,602 → 403,343,582 | 184,344,576 → 43,081,728 | 196,608 → 98,304 | 0 → 0 |
| P05 | 0 → 0 | 296,655,751 → 297,735,584 | 106,496 → 139,264 | 0 → 0 |
| P06 | 302,421,669 → 579,296,346 | 524,924,853 → 17,145,856 | 139,264 → 0 | 273,790,901 → 0 |

ON 轮 late-materialization skipped 变为 0 不是退化：候选 pack 已经在更早阶段被 trim min-max 排除，不再需要 late materialization 做第二次大规模过滤。

## 7. 时间和 RU

| Query | Root time OFF → ON | 变化 | RU OFF → ON | 变化 | DMFile read time OFF → ON（task 累计） |
| --- | ---: | ---: | ---: | ---: | ---: |
| P01 | 156.1 → 55.2 ms | -64.64% | 38,651.35 → 527.84 | -98.63% | 4,216.099 → 106.589 ms |
| P02 | 156.2 → 65.3 ms | -58.19% | 41,942.15 → 4,170.21 | -90.06% | 3,948.624 → 358.249 ms |
| P03 | 167.7 → 84.5 ms | -49.61% | 47,828.49 → 10,832.56 | -77.35% | 4,209.904 → 758.549 ms |
| P04 | 559.4 → 321.9 ms | -42.46% | 106,394.72 → 34,892.46 | -67.20% | 19,080.245 → 9,101.972 ms |
| P05 | 106.5 → 119.5 ms | +12.21% | 39,042.68 → 39,074.67 | +0.08% | 3,070.442 → 3,281.538 ms |
| P06 | 405.0 → 255.5 ms | -36.91% | 77,147.58 → 38,812.54 | -49.69% | 6,142.631 → 2,631.254 ms |

DMFile read time 是数百个并行 read task 的累计时间，不等同于 root wall time。Root time 只有一次正式测量，精确 P50/P95 仍需要多轮重复；pack-filter、扫描量和 RU 的数量级变化已经足以确认优化收益。

P05 的 RU 几乎不变，root time 的 12% 差异属于单次运行波动和轻微 segment 差异，不代表范围外查询发生 trim 优化。

## 8. 原始产物

- [本轮实际执行的 500m SQL](results/2026-07-16/500m/benchmark.sql)
- [ON 完整 SQL 输出](results/2026-07-16/500m/trim-read-on/benchmark-output.tsv)
- [ON 结构化汇总](results/2026-07-16/500m/trim-read-on/summary.json)
- [完整 A/B 机器可读对比](results/2026-07-16/500m/comparison.json)
- [P01 MPP 原始日志](results/2026-07-16/500m/trim-read-on/P01_3h.tso-467708323726360584.mpp.log)
- [P02 MPP 原始日志](results/2026-07-16/500m/trim-read-on/P02_27h.tso-467708323791634433.mpp.log)
- [P03 MPP 原始日志](results/2026-07-16/500m/trim-read-on/P03_3d.tso-467708323857170433.mpp.log)
- [P04 MPP 原始日志](results/2026-07-16/500m/trim-read-on/P04_30d.tso-467708323922706433.mpp.log)
- [P05 MPP 原始日志](results/2026-07-16/500m/trim-read-on/P05_outside.tso-467708324053778433.mpp.log)
- [P06 MPP 原始日志](results/2026-07-16/500m/trim-read-on/P06_production.tso-467708324132421633.mpp.log)

每个 `.mpp.log` 文件保留该 TSO 在 9522、9523 日志中匹配到的原始 `MPPTaskStatistics.cpp` 行，分析按 TSO 汇总两个 `[INFO]`/`FINISHED` task。

实验结束后，两个 TiFlash 实例均保持 `dt_enable_trim_minmax_read=true`。
