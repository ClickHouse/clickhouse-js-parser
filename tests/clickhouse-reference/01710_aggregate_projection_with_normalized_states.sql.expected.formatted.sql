DROP TABLE IF EXISTS r;

SELECT finalizeAggregation(CAST(quantileState(0)(arrayJoin([1, 2, 3])) AS AggregateFunction(quantile(1), UInt8)));

CREATE TABLE r
(
    x String,
    a LowCardinality(String),
    q AggregateFunction(quantilesTiming(0.5, 0.95, 0.99), Int64),
    s Int64,
    PROJECTION p (SELECT a, quantilesTimingMerge(0.5, 0.95, 0.99)(q), sum(s) GROUP BY a)
)
ENGINE = SummingMergeTree()
ORDER BY (x, a)
SETTINGS deduplicate_merge_projection_mode = 'drop'; -- should set it to rebuild once projection is supported with SummingMergeTree

INSERT INTO r SELECT
    number % 100 AS x,
    'x' AS a,
    quantilesTimingState(0.5, 0.95, 0.99)(number::Int64) AS q,
    sum(1) AS s
FROM numbers(1000)
GROUP BY
    x,
    a;

SELECT
    ifNotFinite(quantilesTimingMerge(0.95)(q)[1], 0) AS d1,
    ifNotFinite(quantilesTimingMerge(0.99)(q)[1], 0) AS d2,
    ifNotFinite(quantilesTimingMerge(0.5)(q)[1], 0) AS d3,
    sum(s)
FROM cluster('test_cluster_two_shards', currentDatabase(), r)
WHERE a = 'x'
SETTINGS prefer_localhost_replica = '0';

SELECT
    quantilesTimingMerge(0.95)(q),
    quantilesTimingMerge(toInt64(1))(q)
FROM remote('127.0.0.{1,2}', currentDatabase(), r);

DROP TABLE r;