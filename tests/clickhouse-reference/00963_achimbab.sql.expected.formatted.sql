-- Tags: no-parallel, long
SET output_format_write_statistics = '0';

SELECT
    sum(cnt) > 0 AS total,
    k[1],
    k[2]
FROM (
        SELECT
            arrayMap((x -> x % 3 ? toNullable(number % 5 + x) : NULL), range(3)) AS k,
            number % 4 ? toNullable(rand()) : NULL AS cnt
        FROM `system`.numbers_mt
        WHERE number < 1000000
        LIMIT 1000000
    )
GROUP BY k
WITH TOTALS
ORDER BY k[2] ASC
SETTINGS
    max_threads = '100',
    max_execution_time = '120'
FORMAT JSON;