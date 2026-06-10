-- Tags: no-azure-blob-storage
SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

INSERT INTO test SELECT materialize('{"a" : 42}')::JSON(max_dynamic_paths = 8)
FROM numbers(5);

INSERT INTO test SELECT materialize('{"a1" : 42, "a2" : 42, "a3" : 42, "a4" : 42, "a5" : 42, "a6" : 42, "a7" : 42, "a8" : 42, "a" : [{"c" : 42}]}')::JSON(max_dynamic_paths = 8)
FROM numbers(5);

OPTIMIZE TABLE test FINAL;

SELECT DISTINCT
    dynamicType(json.a) AS type,
    isDynamicElementInSharedData(json.a)
FROM test
ORDER BY type ASC;

INSERT INTO test SELECT materialize('{"a1" : 42, "a2" : 42, "a3" : 42, "a4" : 42, "a5" : 42, "a6" : 42, "a7" : 42, "a8" : 42, "a" : [{"d" : 42}]}')::JSON(max_dynamic_paths = 8)
FROM numbers(5);

SELECT DISTINCT JSONSharedDataPaths(arrayJoin(json.a.:`Array(JSON)`)) AS path
FROM test
ORDER BY path ASC;

SELECT DISTINCT JSONDynamicPaths(arrayJoin(json.a.:`Array(JSON)`)) AS path
FROM test
ORDER BY path ASC;

SELECT DISTINCT
    dynamicType(arrayJoin(json.a.:`Array(JSON)`.c)) AS type,
    isDynamicElementInSharedData(arrayJoin(json.a.:`Array(JSON)`.c))
FROM test
ORDER BY type ASC;

SELECT DISTINCT
    dynamicType(arrayJoin(json.a.:`Array(JSON)`.d)) AS type,
    isDynamicElementInSharedData(arrayJoin(json.a.:`Array(JSON)`.d))
FROM test
ORDER BY type ASC;

DROP TABLE test;