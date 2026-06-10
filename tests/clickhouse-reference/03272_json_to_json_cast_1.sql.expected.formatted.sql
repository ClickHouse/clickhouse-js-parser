SET enable_json_type = '1';

SET enable_analyzer = '1';

SET output_format_native_write_json_as_string = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 2, max_dynamic_types = 2, a UInt32, b String, SKIP c)
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONAsObject;

SELECT
    json::JSON(max_dynamic_paths = 2, max_dynamic_types = 1, a UInt32, b String, SKIP c) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    dynamicType(json2.k2),
    isDynamicElementInSharedData(json2.k2),
    dynamicType(json2.k4),
    isDynamicElementInSharedData(json2.k4)
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 2, max_dynamic_types = 4, a UInt32, b String, SKIP c) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    dynamicType(json2.k2),
    isDynamicElementInSharedData(json2.k2),
    dynamicType(json2.k4),
    isDynamicElementInSharedData(json2.k4)
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 4, max_dynamic_types = 2, a UInt32, b String, SKIP c) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    dynamicType(json2.k2),
    isDynamicElementInSharedData(json2.k2),
    dynamicType(json2.k4),
    isDynamicElementInSharedData(json2.k4)
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 4, max_dynamic_types = 1, a UInt32, b String, SKIP c) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    dynamicType(json2.k2),
    isDynamicElementInSharedData(json2.k2),
    dynamicType(json2.k4),
    isDynamicElementInSharedData(json2.k4)
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 4, max_dynamic_types = 4, a UInt32, b String, SKIP c) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    dynamicType(json2.k2),
    isDynamicElementInSharedData(json2.k2),
    dynamicType(json2.k4),
    isDynamicElementInSharedData(json2.k4)
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 1, max_dynamic_types = 2, a UInt32, b String, SKIP c) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    dynamicType(json2.k2),
    isDynamicElementInSharedData(json2.k2),
    dynamicType(json2.k4),
    isDynamicElementInSharedData(json2.k4)
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 1, max_dynamic_types = 1, a UInt32, b String, SKIP c) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    dynamicType(json2.k2),
    isDynamicElementInSharedData(json2.k2),
    dynamicType(json2.k4),
    isDynamicElementInSharedData(json2.k4)
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 1, max_dynamic_types = 4, a UInt32, b String, SKIP c) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    dynamicType(json2.k2),
    isDynamicElementInSharedData(json2.k2),
    dynamicType(json2.k4),
    isDynamicElementInSharedData(json2.k4)
FROM test;