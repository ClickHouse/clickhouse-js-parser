DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    key Int,
    val1 SimpleAggregateFunction(max, Nullable(Int)),
    val2 SimpleAggregateFunction(min, Int)
)
ENGINE = AggregatingMergeTree()
ORDER BY key;

SYSTEM STOP MERGES data;

INSERT INTO data;

INSERT INTO data;

SELECT
    key,
    val1,
    val2,
    assumeNotNull(val1) > val2 AS x1,
    val1 > val2 AS x2
FROM data FINAL
PREWHERE assumeNotNull(val1) > 0
WHERE x1 != x2
SETTINGS max_threads = '1';