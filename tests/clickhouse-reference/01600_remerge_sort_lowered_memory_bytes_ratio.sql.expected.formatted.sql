-- Tags: no-random-settings
-- Check remerge_sort_lowered_memory_bytes_ratio setting
SET max_memory_usage = '200Mi';

-- enter remerge once limit*2 is reached
SET max_bytes_before_remerge_sort = '10Mi';

-- more blocks
SET max_block_size = '40960';

-- remerge_sort_lowered_memory_bytes_ratio default 2, slightly not enough
--     MergeSortingTransform: Re-merging intermediate ORDER BY data (20 blocks with 819200 rows) to save memory consumption
--     MergeSortingTransform: Memory usage is lowered from 186.25 MiB to 95.00 MiB
--     MergeSortingTransform: Re-merging is not useful (memory usage was not lowered by remerge_sort_lowered_memory_bytes_ratio=2.0)
SELECT
    number AS k,
    repeat(toString(number), 11) AS v1,
    repeat(toString(number), 12) AS v2
FROM numbers(3000000.)
ORDER BY
    v1 ASC,
    v2 ASC
LIMIT 400000.
FORMAT Null; -- { serverError MEMORY_LIMIT_EXCEEDED }

SELECT
    number AS k,
    repeat(toString(number), 11) AS v1,
    repeat(toString(number), 12) AS v2
FROM numbers(3000000.)
ORDER BY
    v1 ASC,
    v2 ASC
LIMIT 400000.
SETTINGS remerge_sort_lowered_memory_bytes_ratio = 2.
FORMAT Null; -- { serverError MEMORY_LIMIT_EXCEEDED }

-- remerge_sort_lowered_memory_bytes_ratio 1.9 is good (need at least 1.91/0.98=1.94)
--     MergeSortingTransform: Re-merging intermediate ORDER BY data (20 blocks with 819200 rows) to save memory consumption
--     MergeSortingTransform: Memory usage is lowered from 186.25 MiB to 95.00 MiB
--     MergeSortingTransform: Re-merging intermediate ORDER BY data (20 blocks with 809600 rows) to save memory consumption
--     MergeSortingTransform: Memory usage is lowered from 188.13 MiB to 95.00 MiB
--     MergeSortingTransform: Re-merging intermediate ORDER BY data (20 blocks with 809600 rows) to save memory consumption
--     MergeSortingTransform: Memory usage is lowered from 188.13 MiB to 95.00 MiB
--     MergeSortingTransform: Re-merging intermediate ORDER BY data (20 blocks with 809600 rows) to save memory consumption
--     MergeSortingTransform: Memory usage is lowered from 188.13 MiB to 95.00 MiB
--     MergeSortingTransform: Re-merging intermediate ORDER BY data (20 blocks with 809600 rows) to save memory consumption
--     MergeSortingTransform: Memory usage is lowered from 188.13 MiB to 95.00 MiB
--     MergeSortingTransform: Re-merging intermediate ORDER BY data (20 blocks with 809600 rows) to save memory consumption
--     MergeSortingTransform: Memory usage is lowered from 188.13 MiB to 95.00 MiB
SELECT
    number AS k,
    repeat(toString(number), 11) AS v1,
    repeat(toString(number), 12) AS v2
FROM numbers(3000000.)
ORDER BY k ASC
LIMIT 400000.
SETTINGS remerge_sort_lowered_memory_bytes_ratio = 1.9
FORMAT Null;