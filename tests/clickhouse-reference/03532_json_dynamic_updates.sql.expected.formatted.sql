-- Tags: long
SET mutations_sync = '1';

DROP TABLE IF EXISTS test_updates;

CREATE TABLE test_updates
(
    id UInt64,
    json JSON,
    dynamic Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '10000000', min_bytes_for_wide_part = '1000000000', index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO test_updates SELECT
    number,
    '{"a" : 42, "b" : 42, "c" : 42}',
    CAST('42' AS Int64)
FROM numbers(100000);

ALTER TABLE test_updates UPDATE json = '{"a" : [1, 2, 3], "d" : 42}' WHERE id >= 50000;

ALTER TABLE test_updates UPDATE dynamic = CAST('[1, 2, 3]' AS Array(Int64)) WHERE id >= 50000;

SELECT DISTINCT arrayJoin(JSONDynamicPaths(json))
FROM test_updates
ORDER BY `all` ASC;

SELECT DISTINCT arrayJoin(JSONSharedDataPaths(json))
FROM test_updates
ORDER BY `all` ASC;

SELECT
    dynamicType(json.a),
    isDynamicElementInSharedData(json.a),
    count()
FROM test_updates
GROUP BY ALL
ORDER BY `all` ASC;

SELECT
    dynamicType(dynamic),
    isDynamicElementInSharedData(dynamic),
    count()
FROM test_updates
GROUP BY ALL
ORDER BY `all` ASC;

SELECT
    json,
    json.a,
    dynamic
FROM test_updates
WHERE id IN (49999, 50000)
ORDER BY id ASC;

SELECT
    json,
    dynamic
FROM test_updates
FORMAT Null;

ALTER TABLE test_updates UPDATE json = '{}' WHERE 1;

ALTER TABLE test_updates UPDATE dynamic = NULL WHERE 1;

DROP TABLE test_updates;

CREATE TABLE test_updates
(
    id UInt64,
    json JSON,
    dynamic Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1', index_granularity = '8192', index_granularity_bytes = '10Mi';