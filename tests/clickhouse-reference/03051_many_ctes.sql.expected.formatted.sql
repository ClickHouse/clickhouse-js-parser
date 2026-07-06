-- https://github.com/ClickHouse/ClickHouse/issues/40955
SET enable_analyzer = '1';

WITH toInt64(2) AS new_x

SELECT new_x AS x
FROM (
        SELECT 1 AS x
    ) AS t;

WITH toInt64(2) AS new_x

SELECT * REPLACE (new_x AS x)
FROM (
        SELECT 1 AS x
    ) AS t;

SELECT 2 AS x
FROM (
        SELECT 1 AS x
    ) AS t;

SELECT * REPLACE (2 AS x)
FROM (
        SELECT 1 AS x
    ) AS t;