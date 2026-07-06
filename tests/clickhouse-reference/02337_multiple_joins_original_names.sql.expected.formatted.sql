-- https://github.com/ClickHouse/ClickHouse/issues/34697
SET enable_analyzer = '1';

SELECT table1_id
FROM (
        SELECT `first`.table1_id
        FROM
            (
                SELECT number + 1 AS table1_id
                FROM numbers(1)
            ) AS `first`
        INNER JOIN (
                SELECT number + 1 AS table2_id
                FROM numbers(1)
            ) AS second
            ON `first`.table1_id = second.table2_id
        INNER JOIN (
                SELECT number + 1 AS table3_id
                FROM numbers(1)
            ) AS third
            ON `first`.table1_id = third.table3_id
    );

SELECT table1_id
FROM (
        SELECT `first`.table1_id
        FROM
            (
                SELECT number + 1 AS table1_id
                FROM numbers(1)
            ) AS `first`
        INNER JOIN (
                SELECT number + 1 AS table2_id
                FROM numbers(1)
            ) AS second
            ON `first`.table1_id = second.table2_id
        INNER JOIN (
                SELECT number + 1 AS table3_id
                FROM numbers(1)
            ) AS third
            ON `first`.table1_id = third.table3_id
    )
SETTINGS multiple_joins_try_to_keep_original_names = '1';

SELECT aaa
FROM (
        SELECT `first`.table1_id AS aaa
        FROM
            (
                SELECT number + 1 AS table1_id
                FROM numbers(1)
            ) AS `first`
        INNER JOIN (
                SELECT number + 1 AS table2_id
                FROM numbers(1)
            ) AS second
            ON `first`.table1_id = second.table2_id
        INNER JOIN (
                SELECT number + 1 AS table3_id
                FROM numbers(1)
            ) AS third
            ON `first`.table1_id = third.table3_id
    )
SETTINGS multiple_joins_try_to_keep_original_names = '1';