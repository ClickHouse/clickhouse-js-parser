--https://github.com/ClickHouse/ClickHouse/issues/59402
CREATE TABLE t1
(
    f1 Int32,
    f2 Map(LowCardinality(String), LowCardinality(String)),
    f3 Map(String, String),
    f4 Map(Int32, Int32)
)
ENGINE = Memory() AS
SELECT
    1 AS f1,
    map(number % 2, number % 10) AS f2,
    f2 AS f3,
    f2 AS f4
FROM numbers(1000111);

SET max_block_size = '10';

-- { echoOn }
SELECT
    f1,
    f2['2'],
    count()
FROM t1
GROUP BY
    1,
    2
ORDER BY
    1 ASC,
    2 ASC;

SELECT
    f1,
    f3['2'],
    count()
FROM t1
GROUP BY
    1,
    2
ORDER BY
    1 ASC,
    2 ASC;

SELECT
    f1,
    f4[2],
    count()
FROM t1
GROUP BY
    1,
    2
ORDER BY
    1 ASC,
    2 ASC;