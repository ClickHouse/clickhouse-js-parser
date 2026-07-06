DROP TABLE IF EXISTS test;

-- #29010
CREATE TABLE test
(
    d DateTime,
    a String,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY d
PARTITION BY toDate(d);

SELECT *
FROM (
        SELECT
            a,
            max((d, b)).2 AS value
        FROM test
        GROUP BY a
        WITH ROLLUP
    )
WHERE a != '';

-- the same query, but after syntax optimization
SELECT
    a,
    value
FROM (
        SELECT
            a,
            max((d, b)).2 AS value
        FROM test
        GROUP BY a
        WITH ROLLUP
        HAVING a != ''
    )
WHERE a != '';