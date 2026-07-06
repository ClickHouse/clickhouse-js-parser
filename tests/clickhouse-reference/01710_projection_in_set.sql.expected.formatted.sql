DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    i UInt64,
    j UInt64,
    k UInt64,
    PROJECTION agg (SELECT sum(j), avg(k) GROUP BY i),
    PROJECTION norm (SELECT j, k ORDER BY i)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO x;

SET optimize_use_projections = '1', use_index_for_in_with_subqueries = '0';

SELECT
    sum(j),
    avg(k)
FROM x
WHERE i IN (
        SELECT number
        FROM numbers(4)
    );

SELECT
    j,
    k
FROM x
WHERE i IN (
        SELECT number
        FROM numbers(4)
    );

DROP TABLE x;

-- Projection analysis should not break other IN constructs. See https://github.com/ClickHouse/ClickHouse/issues/35336
CREATE TABLE IF NOT EXISTS flows
(
    SrcAS UInt32,
    Bytes UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO flows;

SELECT if(SrcAS IN (
        SELECT SrcAS
        FROM flows
        GROUP BY SrcAS
        ORDER BY sum(Bytes) DESC
        LIMIT 10
    ), SrcAS, 33) AS SrcAS
FROM flows
WHERE 2 = 2
ORDER BY SrcAS ASC;

DROP TABLE flows;