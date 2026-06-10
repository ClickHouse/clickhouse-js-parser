-- https://github.com/ClickHouse/ClickHouse/issues/58985
DROP TABLE IF EXISTS test_03093;

CREATE TABLE test_03093
(
    app String,
    c UInt64,
    k Map(String, String)
)
ENGINE = MergeTree()
ORDER BY app;

INSERT INTO test_03093;

INSERT INTO test_03093;

INSERT INTO test_03093;

SET enable_analyzer = '1';

SELECT
    app,
    arrayZip(untuple(sumMap(k.keys, replicate(1, k.keys))))
FROM test_03093
PREWHERE c > 1
GROUP BY app;

SELECT
    app,
    arrayZip(untuple(sumMap(k.keys, replicate(1, k.keys))))
FROM test_03093
WHERE c > 1
GROUP BY app;