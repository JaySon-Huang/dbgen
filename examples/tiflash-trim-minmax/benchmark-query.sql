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
FROM bc_bet_records_213 AS b
WHERE category_id IN (5)
  AND settle_status = 2
  AND settle_time >= '2026-07-14 21:00:00'
  AND settle_time <= '2026-07-15 23:59:59'
  AND site_code = '213'
  AND currency = 'CNY'
ORDER BY settle_time DESC
LIMIT 0, 100;
