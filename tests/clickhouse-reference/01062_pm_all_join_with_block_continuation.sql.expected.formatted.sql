-- Tags: no-asan, long
-- test is slow to pass flaky check when changed
SET max_memory_usage = '50000000';

SET join_algorithm = 'partial_merge';

SET analyzer_compatibility_join_using_top_level_identifier = '1';

SET joined_block_split_single_row = '0';

SELECT count(1)
FROM (
        SELECT
            materialize(1) AS k,
            n
        FROM
            numbers(10) AS nums
        INNER JOIN (
                SELECT
                    materialize(1) AS k,
                    number AS n
                FROM numbers(1000000)
            ) AS j
            USING (k)
    );

SELECT count(1)
FROM (
        SELECT
            materialize(1) AS k,
            n
        FROM
            numbers(1000) AS nums
        INNER JOIN (
                SELECT
                    materialize(1) AS k,
                    number AS n
                FROM numbers(10000)
            ) AS j
            USING (k)
    );

SELECT
    count(1),
    uniqExact(n)
FROM (
        SELECT
            materialize(1) AS k,
            n
        FROM
            numbers(1000000) AS nums
        INNER JOIN (
                SELECT
                    materialize(1) AS k,
                    number AS n
                FROM numbers(10)
            ) AS j
            USING (k)
    );

SET max_joined_block_size_rows = '0';

SET query_plan_join_swap_table = 'false';

-- Because of the optimizations in the analyzer the following queries started to run without issues. To keep the essence of the test, we test both cases.
SELECT count(1)
FROM (
        SELECT
            materialize(1) AS k,
            n
        FROM
            numbers(10) AS nums
        INNER JOIN (
                SELECT
                    materialize(1) AS k,
                    number AS n
                FROM numbers(1000000)
            ) AS j
            USING (k)
    )
SETTINGS enable_analyzer = '0'; -- { serverError MEMORY_LIMIT_EXCEEDED }

SELECT count(1)
FROM (
        SELECT
            materialize(1) AS k,
            n
        FROM
            numbers(1000) AS nums
        INNER JOIN (
                SELECT
                    materialize(1) AS k,
                    number AS n
                FROM numbers(10000)
            ) AS j
            USING (k)
    )
SETTINGS enable_analyzer = '0'; -- { serverError MEMORY_LIMIT_EXCEEDED }

SELECT count(1)
FROM (
        SELECT
            materialize(1) AS k,
            n
        FROM
            numbers(10) AS nums
        INNER JOIN (
                SELECT
                    materialize(1) AS k,
                    number AS n
                FROM numbers(1000000)
            ) AS j
            USING (k)
    )
SETTINGS enable_analyzer = '1';

SELECT count(1)
FROM (
        SELECT
            materialize(1) AS k,
            n
        FROM
            numbers(1000) AS nums
        INNER JOIN (
                SELECT
                    materialize(1) AS k,
                    number AS n
                FROM numbers(10000)
            ) AS j
            USING (k)
    )
SETTINGS enable_analyzer = '1';

SET max_joined_block_size_rows = '2000';

SELECT
    count(1),
    uniqExact(n)
FROM (
        SELECT
            materialize(1) AS k,
            n
        FROM
            numbers(1000) AS nums
        INNER JOIN (
                SELECT
                    materialize(1) AS k,
                    number AS n
                FROM numbers(10000)
            ) AS j
            USING (k)
    );

SET max_rows_in_join = '1000';