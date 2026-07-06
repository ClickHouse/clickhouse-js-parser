DROP TABLE IF EXISTS test02416;

CREATE TABLE test02416
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY (a, b);

INSERT INTO test02416 SELECT
    number % 2 AS a,
    number AS b
FROM numbers(10);

-- { echoOn }
SELECT
    count() AS amount,
    a,
    b,
    grouping(a, b)
FROM test02416
GROUP BY GROUPING SETS ((a, b), (a), ())
ORDER BY (amount, a, b) ASC;

SELECT
    count() AS amount,
    a,
    b,
    grouping(a, b)
FROM test02416
GROUP BY
    a,
    b
WITH ROLLUP
ORDER BY (amount, a, b) ASC;

-- { echoOff }
DROP TABLE test02416;