-- Tags: no-tsan, no-asan, no-msan, no-replicated-database, no-random-settings
-- Tag no-tsan: Fine thresholds on memory usage
-- Tag no-asan: Fine thresholds on memory usage
-- Tag no-msan: Fine thresholds on memory usage
-- each uniqCombined state should not use > sizeof(HLL) in memory,
-- sizeof(HLL) is (2^K * 6 / 8)
-- hence max_memory_usage for 100 rows = (96<<10)*100 = 9830400
SET use_uncompressed_cache = '0';

SET memory_profiler_step = '1';

SET max_memory_usage = '4000000';

SELECT sum(u)
FROM (
        SELECT
            intDiv(number, 8192) AS k,
            uniqCombined(number % 8192) AS u
        FROM numbers(8192 * 100)
        GROUP BY k
    ); -- { serverError MEMORY_LIMIT_EXCEEDED }

SET max_memory_usage = '9830400';

SELECT sum(u)
FROM (
        SELECT
            intDiv(number, 4096) AS k,
            uniqCombined(reinterpretAsString(number % 4096)) AS u
        FROM numbers(4096 * 100)
        GROUP BY k
    ); -- { serverError MEMORY_LIMIT_EXCEEDED }

SET max_memory_usage = '2000000';

SELECT sum(u)
FROM (
        SELECT
            intDiv(number, 4096) AS k,
            uniqCombined(16)(number % 4096) AS u
        FROM numbers(4096 * 100)
        GROUP BY k
    ); -- { serverError MEMORY_LIMIT_EXCEEDED }

SET max_memory_usage = '5230000';

SELECT sum(u)
FROM (
        SELECT
            intDiv(number, 2048) AS k,
            uniqCombined(16)(reinterpretAsString(number % 2048)) AS u
        FROM numbers(2048 * 100)
        GROUP BY k
    ); -- { serverError MEMORY_LIMIT_EXCEEDED }

SET max_memory_usage = '5900000';

SET max_memory_usage = '8000000';

SELECT sum(u)
FROM (
        SELECT
            intDiv(number, 16384) AS k,
            uniqCombined(18)(number % 16384) AS u
        FROM numbers(16384 * 100)
        GROUP BY k
    ); -- { serverError MEMORY_LIMIT_EXCEEDED }

SET max_memory_usage = '19660800';

SELECT sum(u)
FROM (
        SELECT
            intDiv(number, 8192) AS k,
            uniqCombined(18)(reinterpretAsString(number % 8192)) AS u
        FROM numbers(8192 * 100)
        GROUP BY k
    ); -- { serverError MEMORY_LIMIT_EXCEEDED }