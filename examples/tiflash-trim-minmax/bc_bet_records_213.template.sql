{{ @dataset_rows := coalesce(@dataset_rows, 1000000) }}
{{ @sentinel_probability := coalesce(@sentinel_probability, 0.0001) }}
{{ @window_seconds := 7776000 }}
{{ @start_epoch := 1776384000 }}
{{ @sentinel_epoch := 4102444800 }}
{{ @start_time := TIMESTAMP '2026-04-17 00:00:00' }}
{{ @sentinel_time := TIMESTAMP '2100-01-01 00:00:00' }}
{{ @other_categories := array[1, 2, 3, 4, 6, 7, 8] }}
{{ @devices := array['desktop', 'ios', 'android', 'h5'] }}
{{ @odds_types := array['EU', 'HK', 'ID', 'MY'] }}
{{ @sports_types := array['football', 'basketball', 'tennis', 'esports'] }}

CREATE TABLE bc_bet_records_213 (
    id bigint NOT NULL COMMENT '雪花ID'
        /*{{
            @normal_epoch := @start_epoch + div(
                (rownum - 1) * (@window_seconds - 1),
                greatest(@dataset_rows - 1, 1)
            );
            @normal_settle_time := @start_time + INTERVAL (@normal_epoch - @start_epoch) SECOND;
            @is_sentinel := rand.bool(@sentinel_probability);
            @settle_time := CASE WHEN @is_sentinel THEN @sentinel_time ELSE @normal_settle_time END;
            7000000000000000000 + rownum
        }}*/,
    record_id varchar(256) NOT NULL COMMENT '同步给GO的字段'
        /*{{ 'rec-' || rownum }}*/,
    order_no varchar(256) NOT NULL COMMENT '三方订单ID'
        /*{{ 'ord-' || rownum }}*/,
    round_id varchar(128) DEFAULT '' COMMENT '三方牌局ID'
        /*{{ 'round-' || div(rownum - 1, 10) }}*/,
    platform_id int NOT NULL COMMENT '平台ID'
        /*{{ 213 }}*/,
    category_id int NOT NULL DEFAULT '0' COMMENT '游戏大类ID'
        /*{{ CASE WHEN rand.bool(0.25) THEN 5 ELSE @other_categories[rand.range(1, 8)] END }}*/,
    site_code varchar(32) NOT NULL DEFAULT '' COMMENT '站点代码'
        /*{{ '213' }}*/,
    site_prefix varchar(32) NOT NULL DEFAULT '' COMMENT '站点前缀'
        /*{{ 's213' }}*/,
    agent_code varchar(32) NOT NULL DEFAULT '' COMMENT '代理ID'
        /*{{ 'agent-' || mod(rownum, 1000) }}*/,
    account varchar(64) NOT NULL DEFAULT '' COMMENT '用户ID'
        /*{{ 'acct-' || mod(rownum, 10000000) }}*/,
    third_user_name varchar(128) NOT NULL COMMENT '三方账号'
        /*{{ 'third-' || mod(rownum, 10000000) }}*/,
    pull_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '拉单时间'
        /*{{ @normal_settle_time + INTERVAL rand.range(1, 300) SECOND }}*/,
    third_game_code varchar(64) NOT NULL DEFAULT '' COMMENT '三方游戏代码'
        /*{{ 'game-' || mod(rownum, 1000) }}*/,
    all_bet decimal(19, 6) NOT NULL DEFAULT '0.00000000' COMMENT '总投注额'
        /*{{ @all_bet := round(rand.uniform(1.0, 10000.0), 6) }}*/,
    valid_bet decimal(19, 6) NOT NULL DEFAULT '0.00000000' COMMENT '有效投注额'
        /*{{ round(@all_bet * rand.uniform(0.5, 1.0), 6) }}*/,
    net_profit decimal(19, 6) NOT NULL DEFAULT '0.00000000' COMMENT '盈亏额'
        /*{{ @net_profit := round(rand.uniform(-5000.0, 5000.0), 6) }}*/,
    rake decimal(19, 6) DEFAULT '0' COMMENT '棋牌-抽水'
        /*{{ round(rand.uniform(0.0, 50.0), 6) }}*/,
    jackpot decimal(19, 6) DEFAULT '0' COMMENT '电子-奖池jackpot'
        /*{{ round(rand.uniform(0.0, 20.0), 6) }}*/,
    bet_time datetime NOT NULL COMMENT '投注时间'
        /*{{ @bet_lag := rand.range(300, 21600); @bet_time := @normal_settle_time - INTERVAL @bet_lag SECOND }}*/,
    bet_time_stamp bigint NOT NULL DEFAULT '0' COMMENT '投注时间戳'
        /*{{ @normal_epoch - @bet_lag }}*/,
    settle_time datetime DEFAULT '2100-01-01 00:00:00' COMMENT '结算时间'
        /*{{ @settle_time }}*/,
    settle_time_stamp bigint NOT NULL DEFAULT '0' COMMENT '结算时间戳'
        /*{{ CASE WHEN @is_sentinel THEN @sentinel_epoch ELSE @normal_epoch END }}*/,
    settle_status int NOT NULL DEFAULT '1' COMMENT '结算状态,1:未结算 2:已结算 3:撤销'
        /*{{ CASE WHEN @is_sentinel THEN 1 WHEN rand.bool(0.001) THEN 3 ELSE 2 END }}*/,
    device varchar(512) DEFAULT '' COMMENT '投注设备'
        /*{{ @devices[rand.range(1, 5)] }}*/,
    bet_ip varchar(64) DEFAULT '' COMMENT '投注IP'
        /*{{ '10.' || mod(div(rownum, 65536), 256) || '.' || mod(div(rownum, 256), 256) || '.' || mod(rownum, 256) }}*/,
    third_group_code varchar(32) NOT NULL DEFAULT '' COMMENT '三方游戏组ID'
        /*{{ 'group-' || mod(rownum, 100) }}*/,
    after_balance decimal(19, 6) DEFAULT '0' COMMENT '投注后余额'
        /*{{ round(rand.uniform(0.0, 100000.0) + @net_profit, 6) }}*/,
    is_combo tinyint(1) DEFAULT '0' COMMENT '体育-是否串关'
        /*{{ rand.bool(0.10) }}*/,
    odds_type varchar(64) DEFAULT '' COMMENT '体育-盘口类型 欧洲盘 香港盘 印尼盘 马来盘,值不固定'
        /*{{ @odds_types[rand.range(1, 5)] }}*/,
    odds decimal(19, 6) DEFAULT '0' COMMENT '体育-赔率'
        /*{{ round(rand.uniform(1.01, 10.0), 6) }}*/,
    order_status varchar(32) DEFAULT '' COMMENT '体育-订单状态,各体育平台订单状态值不固定'
        /*{{ CASE WHEN @is_sentinel THEN 'pending' ELSE 'settled' END }}*/,
    sports_type varchar(64) DEFAULT '' COMMENT '体育-体育类型'
        /*{{ @sports_types[rand.range(1, 5)] }}*/,
    winlost_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '结账时间'
        /*{{ @normal_settle_time }}*/,
    game_id int NOT NULL DEFAULT '0' COMMENT '游戏ID'
        /*{{ 10000 + mod(rownum, 1000) }}*/,
    currency varchar(16) NOT NULL DEFAULT '' COMMENT '币种'
        /*{{ 'CNY' }}*/,
    settle_time_zone datetime NOT NULL DEFAULT '2100-01-01 00:00:00' COMMENT '结算时间'
        /*{{ @settle_time }}*/,
    version_no int NOT NULL DEFAULT '0' COMMENT '更新版本，默认0,每次更新会加1'
        /*{{ mod(rownum, 4) }}*/,
    tax_rate decimal(19, 6) NOT NULL DEFAULT '0' COMMENT '税率'
        /*{{ @tax_rate := round(rand.uniform(0.0, 0.05), 6) }}*/,
    tax decimal(19, 6) NOT NULL DEFAULT '0' COMMENT '税金'
        /*{{ round(@all_bet * @tax_rate, 6) }}*/,
    reward decimal(19, 6) NOT NULL DEFAULT '0' COMMENT '三方奖励'
        /*{{ round(rand.uniform(0.0, 100.0), 6) }}*/,
    tipping decimal(19, 6) NOT NULL DEFAULT '0' COMMENT '打赏'
        /*{{ round(rand.uniform(0.0, 20.0), 6) }}*/,
    insurance decimal(19, 6) NOT NULL DEFAULT '0' COMMENT '保险费用'
        /*{{ round(rand.uniform(0.0, 50.0), 6) }}*/,
    props decimal(19, 6) NOT NULL DEFAULT '0' COMMENT '道具费用'
        /*{{ round(rand.uniform(0.0, 30.0), 6) }}*/,
    star int NOT NULL DEFAULT '0' COMMENT '连消次数'
        /*{{ rand.range(0, 10) }}*/,
    settle_date date NOT NULL COMMENT '结算日期'
        /*{{ CASE WHEN @is_sentinel THEN '2100-01-01' ELSE substring(@normal_settle_time || '' FROM 1 FOR 10) END }}*/,
    PRIMARY KEY (id) /*T![clustered_index] NONCLUSTERED */,
    UNIQUE KEY uk_orderno_platformid (order_no, platform_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_bin
/*T! SHARD_ROW_ID_BITS=4 PRE_SPLIT_REGIONS=3 */;
