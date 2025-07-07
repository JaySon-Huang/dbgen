select
    tidb_database,
    tidb_table,
    table_id,
    round(total_stable_size / 1024 / 1024, 0) as stable_mb,
    round(total_stable_size_on_disk / 1024 / 1024, 0) as stable_disk_mb,
    round(avg_stable_rows, 0) as avg_stable_rows,
    round(avg_stable_size / 1024 / 1024, 0) as avg_stable_mb,
    round(total_stable_size_on_disk / 1024.0 / 1024 / segment_count, 0) as avg_stable_disk_mb,
    segment_count,
    round(delta_index_size / 1024 / 1024) as delta_idx_mb,
    round(delta_cache_size / 1024 / 1024, 0) as delta_cache_mb,
    total_delta_rows,
    round(total_delta_size / 1024 / 1024, 0) as total_delta_mb,
    delta_count
from
    information_schema.tiflash_tables
where
    segment_count > 5 and avg_stable_rows < 400000
order by
    stable_disk_mb desc
limit
    100
