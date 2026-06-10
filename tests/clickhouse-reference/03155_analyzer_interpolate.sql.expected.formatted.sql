-- https://github.com/ClickHouse/ClickHouse/issues/62464
SET enable_analyzer = '1';

SELECT
    n,
    [number] AS inter
FROM (
        SELECT
            toFloat32(number % 10) AS n,
            number
        FROM numbers(10)
        WHERE number % 3 = 1
    )
GROUP BY
    n,
    inter
ORDER BY n ASC WITH FILL FROM 0 TO 5.51 STEP 0.5 INTERPOLATE (inter AS [5]);

SELECT
    n,
    number + 5 AS inter
FROM (
        -- { serverError NOT_AN_AGGREGATE }
        SELECT
            toFloat32(number % 10) AS n,
            number,
            number * 2 AS mn
        FROM numbers(10)
        WHERE number % 3 = 1
    )
GROUP BY
    n,
    inter
ORDER BY n ASC WITH FILL FROM 0 TO 5.51 STEP 0.5 INTERPOLATE (inter AS mn * 2);

-- https://github.com/ClickHouse/ClickHouse/issues/64636
SELECT sum(number) AS s
FROM remote('127.0.0.{1,2}', numbers(10))
WHERE (intDiv(number, 2) AS key) != 1
GROUP BY key
ORDER BY key ASC WITH FILL INTERPOLATE (s AS 100500);

-- https://github.com/ClickHouse/ClickHouse/issues/71858
-- https://github.com/ClickHouse/clickhouse-core-incidents/issues/381
SELECT
    number AS ad,
    number,
    number AS pd
FROM numbers(5)
ORDER BY number * 10 ASC WITH FILL INTERPOLATE (pd AS pd + 100, ad AS ad + 1000);