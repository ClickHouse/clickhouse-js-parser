-- Tags: no-random-settings, no-fasttest, no-tsan, no-asan, no-msan
SET allow_suspicious_fixed_string_types = '1';

CREATE TABLE fat_granularity
(
    x UInt32,
    fat FixedString(160000)
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS storage_policy = 's3_cache';

SET max_memory_usage = '10G';

INSERT INTO fat_granularity SELECT
    number,
    toString(number) || '_'
FROM numbers(100000)
SETTINGS
    max_block_size = '3000',
    max_insert_threads = '8',
    min_insert_block_size_rows = '0',
    min_insert_block_size_bytes = '0';

-- Too large sizes of FixedString to deserialize
SELECT x
FROM fat_granularity
PREWHERE fat LIKE '256\\_%'
SETTINGS max_threads = '2';