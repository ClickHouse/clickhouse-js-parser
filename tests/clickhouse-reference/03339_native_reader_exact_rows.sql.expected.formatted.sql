-- Tags: long
-- We use temporary files that uses NativeReader, with a block slightly bigger
-- then power of two, previously it rounds the allocation up to power of 2,
-- which leads to excessive memory usage.
-- This will create a temporary buffer of two columns for the total of 5m rows
SELECT number
FROM numbers(5000000.)
ORDER BY number * 1234567890123456789 ASC
LIMIT 20
OFFSET 4999980
SETTINGS
    max_threads = '1',
    max_memory_usage = '220Mi',
    max_block_size = '65540',
    max_bytes_before_external_sort = '2Mi',
    max_bytes_ratio_before_external_sort = '0'
FORMAT Null;