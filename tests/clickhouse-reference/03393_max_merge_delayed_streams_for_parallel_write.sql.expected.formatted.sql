-- Tags: no-fasttest, long, no-parallel, no-flaky-check, no-msan
-- - no-fasttest -- S3 is required
-- - no-flaky-check -- not compatible with ThreadFuzzer
-- The real example with metric_log with 1200+ columns!
SYSTEM FLUSH LOGS `system`.metric_log;

CREATE TABLE metric_log AS `system`.metric_log
ENGINE = MergeTree()
ORDER BY ()
PARTITION BY ()
SETTINGS storage_policy = 's3_no_cache', min_rows_for_wide_part = '0', min_bytes_for_wide_part = '0', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '1', min_bytes_for_full_part_storage = '0', max_merge_delayed_streams_for_parallel_write = '100', merge_selector_base = '1000', min_columns_to_activate_adaptive_write_buffer = '0', auto_statistics_types = '';

INSERT INTO metric_log SELECT *
FROM generateRandom()
LIMIT 10;

OPTIMIZE TABLE metric_log FINAL;

SYSTEM FLUSH LOGS part_log;

SELECT
    'max_merge_delayed_streams_for_parallel_write=100' AS test,
    *
FROM `system`.part_log
WHERE table = 'metric_log'
    AND database = currentDatabase()
    AND event_date >= yesterday()
    AND event_type = 'MergeParts'
    AND peak_memory_usage > 1000000000
FORMAT Vertical;

ALTER TABLE metric_log MODIFY SETTING max_merge_delayed_streams_for_parallel_write = '10000';

SELECT
    'max_merge_delayed_streams_for_parallel_write=1000' AS test,
    count() AS count
FROM `system`.part_log
WHERE table = 'metric_log'
    AND database = currentDatabase()
    AND event_date >= yesterday()
    AND event_type = 'MergeParts'
    AND peak_memory_usage > 1000000000;