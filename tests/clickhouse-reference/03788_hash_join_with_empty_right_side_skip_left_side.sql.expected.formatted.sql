SELECT count()
FROM
    (
        SELECT number AS x
        FROM `system`.numbers
        WHERE x % 10 > 20
    ) AS a
INNER JOIN (
        SELECT toUInt64(1) AS y
        WHERE 0
    ) AS b
    ON a.x = b.y
SETTINGS
    join_algorithm = 'hash',
    query_plan_join_swap_table = '0';

SELECT count()
FROM
    (
        SELECT number AS x
        FROM `system`.numbers
        WHERE x % 10 > 20
    ) AS a
INNER JOIN (
        SELECT toUInt64(1) AS y
        WHERE 0
    ) AS b
    ON a.x = b.y
SETTINGS
    join_algorithm = 'parallel_hash',
    query_plan_join_swap_table = '0';

SELECT count()
FROM
    (
        SELECT number AS x
        FROM `system`.numbers
    ) AS a
INNER JOIN (
        SELECT toUInt64(1) AS y
        WHERE 0
    ) AS b
    ON a.x = b.y
SETTINGS
    enable_join_runtime_filters = '1',
    query_plan_join_swap_table = '0';

SELECT count()
FROM
    (
        SELECT sum(number) AS x
        FROM `system`.numbers
    ) AS a
INNER JOIN (
        SELECT toUInt64(1) AS y
        WHERE 0
    ) AS b
    ON a.x = b.y
SETTINGS
    join_algorithm = 'parallel_hash',
    query_plan_join_swap_table = '0';

-- CROSS JOIN
SELECT count()
FROM
    (
        SELECT sum(number) AS x
        FROM `system`.numbers
    ) AS a
CROSS JOIN (
        SELECT toUInt64(1) AS y
        WHERE 0
    ) AS b
SETTINGS query_plan_join_swap_table = '0';

-- COMMA CROSS JOIN
SELECT count()
FROM
    (
        SELECT sum(number) AS x
        FROM `system`.numbers
    ) AS a,
    (
        SELECT toUInt64(1) AS y
        WHERE 0
    ) AS b
SETTINGS query_plan_join_swap_table = '0';

SELECT count()
FROM
    numbers(1000000000000.) AS t1,
    null('x UInt8') AS t2
SETTINGS
    query_plan_join_swap_table = '0',
    max_rows_to_read = 10000000000000.;

SELECT count()
FROM
    numbers(1000000000000.) AS t1,
    numbers(1000000000000.) AS t2,
    numbers(1000000000000.) AS t3,
    numbers(1000000000000.) AS t4,
    null('x UInt8') AS t5
SETTINGS
    query_plan_join_swap_table = '0',
    max_rows_to_read = 10000000000000.;