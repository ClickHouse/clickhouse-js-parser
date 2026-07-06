SET enable_json_type = '1';

SET enable_analyzer = '1';

SET output_format_native_write_json_as_string = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 2, k1 UInt32, k2 String)
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONAsObject;

SELECT
    json::JSON(max_dynamic_paths = 2, k1 UInt32, k2 String, k3 UInt32, k6 Bool, k7 UInt32) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4,
    json2.k5,
    json2.k6,
    json2.k7
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 2) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4,
    json2.k5,
    json2.k6,
    json2.k7
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 2, k1 UInt32, k2 DateTime) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4,
    json2.k5,
    json2.k6,
    json2.k7
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 2, k1 UInt32, SKIP k2) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4,
    json2.k5,
    json2.k6,
    json2.k7
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 2, k2 DateTime, k3 UInt32, k6 Bool, k7 UInt32) AS json2,
    JSONDynamicPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4,
    json2.k5,
    json2.k6,
    json2.k7
FROM test;

DROP TABLE test;