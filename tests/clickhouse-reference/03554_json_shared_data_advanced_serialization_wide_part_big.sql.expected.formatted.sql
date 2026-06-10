-- Tags: long
-- Random settings limits: index_granularity=(100, None); index_granularity_bytes=(100000, None)
DROP TABLE IF EXISTS test_wide_advanced;

CREATE TABLE test_wide_advanced
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'advanced', object_shared_data_serialization_version_for_zero_level_parts = 'advanced', object_shared_data_buckets_for_wide_part = '2';

INSERT INTO test_wide_advanced SELECT multiIf(number < 15000, '{"?1" : 1, "?2" : 1, "?3" : 1, "?4" : 1, "?5" : 1, "?6" : 1, "?7" : 1, "?8" : 1}', number < 20000, '{"a" : {"a1" : 1, "a2" : 2, "arr" : [{"arr1" : 3, "arr2" : 4, "arr3" : 5, "arr4" : 6}]}, "b" : 7, "c" : 8, "arr" : [{"arr1" : 9, "arr2" : 10, "arr3" : 11, "arr4" : 12}]}', number < 25000, '{}', number < 30000, '{"a" : {"a1" : 3, "a2" : 4, "arr" : [{"arr1" : 5, "arr2" : 6, "arr3" : 7, "arr4" : 8}]}}', number < 35000, '{"b" : 9, "c" : 10}', number < 40000, '{"arr" : [{"arr1" : 11, "arr2" : 12, "arr3" : 13, "arr4" : 14}]}', '{"a" : {"a1" : 5, "a2" : 6}}')
FROM numbers(45000);

SELECT json
FROM test_wide_advanced
FORMAT Null;

SELECT json.b
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.b,
    json.c
FROM test_wide_advanced
FORMAT Null;

SELECT json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr2
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr.:`Array(JSON)`.arr2,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr4
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr.:`Array(JSON)`.arr4,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr99
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr.:`Array(JSON)`.arr99,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr
FROM test_wide_advanced
FORMAT Null;

SELECT
    json,
    json.b,
    json.c
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.b,
    json.c,
    json
FROM test_wide_advanced
FORMAT Null;

SELECT
    json,
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1,
    json
FROM test_wide_advanced
FORMAT Null;

SELECT
    json,
    json.b,
    json.c,
    json.arr,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1,
    json.arr,
    json
FROM test_wide_advanced
FORMAT Null;

SELECT json.^a
FROM test_wide_advanced
FORMAT Null;

SELECT
    json,
    json.^a
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.^a,
    json.a.a1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.a.a1,
    json.^a
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a
FROM test_wide_advanced
FORMAT Null;

SELECT
    json,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a,
    json
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a
FROM test_wide_advanced
FORMAT Null;

SELECT
    json,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
FORMAT Null;

SELECT
    json,
    json.arr.:`Array(JSON)`.arr1,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_wide_advanced
FORMAT Null;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json.arr.:`Array(JSON)`.arr1,
    json
FROM test_wide_advanced
FORMAT Null;

DROP TABLE test_wide_advanced;