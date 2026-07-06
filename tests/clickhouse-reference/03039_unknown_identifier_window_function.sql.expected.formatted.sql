-- https://github.com/ClickHouse/ClickHouse/issues/45535
SET enable_analyzer = '1';

SELECT
    *,
    count() OVER () AS c
FROM numbers(10)
ORDER BY toString(number) ASC;

WITH toString(number) AS str

SELECT
    *,
    count() OVER () AS c
FROM numbers(10)
ORDER BY str ASC;

SELECT
    *,
    count() OVER () AS c,
    toString(number) AS str
FROM numbers(10)
ORDER BY str ASC;

WITH test AS (
    SELECT
        *,
        count() OVER () AS c
    FROM numbers(10)
)

SELECT *
FROM test
ORDER BY toString(number) ASC;