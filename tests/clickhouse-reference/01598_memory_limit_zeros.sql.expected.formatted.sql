-- Tags: no-parallel, no-fasttest, no-random-settings
SET max_memory_usage = '1', max_untracked_memory = '1000000', max_threads = '40';

SELECT
    'test',
    count(*)
FROM zeros_mt(1000000)
WHERE NOT ignore(zero); -- { serverError MEMORY_LIMIT_EXCEEDED }