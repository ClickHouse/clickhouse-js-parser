SELECT uniqCombined(number)
FROM numbers(10000)
GROUP BY number
WITH TOTALS
ORDER BY number DESC
LIMIT 10
SETTINGS
    max_bytes_before_external_group_by = '1',
    max_bytes_ratio_before_external_group_by = '0',
    max_rows_to_group_by = '10000000000',
    group_by_overflow_mode = 'any',
    totals_mode = 'before_having',
    max_untracked_memory = '0',
    group_by_two_level_threshold = '10000',
    max_block_size = '1000',
    max_threads = '1';