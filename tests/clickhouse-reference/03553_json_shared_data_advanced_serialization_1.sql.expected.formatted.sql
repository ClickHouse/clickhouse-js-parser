-- Tags: long, no-azure-blob-storage
SET output_format_json_quote_64bit_integers = '0';

DROP TABLE IF EXISTS source;

CREATE TABLE source
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = Memory();

INSERT INTO source FORMAT JSONAsObject;

DROP TABLE IF EXISTS test_compact_without_substreams_advanced;

CREATE TABLE test_compact_without_substreams_advanced
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '200G', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '0', object_serialization_version = 'v3', object_shared_data_serialization_version = 'advanced', object_shared_data_serialization_version_for_zero_level_parts = 'advanced', object_shared_data_buckets_for_compact_part = '2';

INSERT INTO test_compact_without_substreams_advanced SELECT *
FROM source;

SELECT json
FROM test_compact_without_substreams_advanced;

DROP TABLE test_compact_without_substreams_advanced;

DROP TABLE IF EXISTS test_compact_advanced;

CREATE TABLE test_compact_advanced
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '200G', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'advanced', object_shared_data_serialization_version_for_zero_level_parts = 'advanced', object_shared_data_buckets_for_compact_part = '2';

INSERT INTO test_compact_advanced SELECT *
FROM source;

SELECT json
FROM test_compact_advanced;

SELECT json.b
FROM test_compact_advanced;

SELECT
    json.b,
    json.c
FROM test_compact_advanced;

SELECT json.arr.:`Array(JSON)`.arr1
FROM test_compact_advanced;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr2
FROM test_compact_advanced;

SELECT
    json.arr.:`Array(JSON)`.arr2,
    json.arr.:`Array(JSON)`.arr1
FROM test_compact_advanced;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr4
FROM test_compact_advanced;

SELECT
    json.arr.:`Array(JSON)`.arr4,
    json.arr.:`Array(JSON)`.arr1
FROM test_compact_advanced;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr99
FROM test_compact_advanced;

SELECT
    json.arr,
    json.arr.:`Array(JSON)`.arr1
FROM test_compact_advanced;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr
FROM test_compact_advanced;

SELECT
    json,
    json.b,
    json.c
FROM test_compact_advanced;

SELECT
    json.b,
    json.c,
    json
FROM test_compact_advanced;

SELECT
    json,
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1
FROM test_compact_advanced;

SELECT
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1,
    json
FROM test_compact_advanced;

SELECT
    json,
    json.b,
    json.c,
    json.arr,
    json.arr.:`Array(JSON)`.arr1
FROM test_compact_advanced;

SELECT
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1,
    json.arr,
    json
FROM test_compact_advanced;

SELECT json.^a
FROM test_compact_advanced;

SELECT
    json,
    json.^a
FROM test_compact_advanced;

SELECT
    json.^a,
    json.a.a1
FROM test_compact_advanced;

SELECT
    json.a.a1,
    json.^a
FROM test_compact_advanced;

SELECT
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1
FROM test_compact_advanced;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a
FROM test_compact_advanced;

SELECT
    json,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a
FROM test_compact_advanced;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a,
    json
FROM test_compact_advanced;

SELECT
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_compact_advanced;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a
FROM test_compact_advanced;

SELECT
    json,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_compact_advanced;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json
FROM test_compact_advanced;

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_compact_advanced;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json.arr.:`Array(JSON)`.arr1
FROM test_compact_advanced;

SELECT
    json,
    json.arr.:`Array(JSON)`.arr1,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_compact_advanced;

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json.arr.:`Array(JSON)`.arr1,
    json
FROM test_compact_advanced;

DROP TABLE test_compact_advanced;

DROP TABLE IF EXISTS test_compact_advanced_tuple;

CREATE TABLE test_compact_advanced_tuple
(
    json Tuple(data JSON(max_dynamic_paths = 8))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '200G', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'advanced', object_shared_data_serialization_version_for_zero_level_parts = 'advanced', object_shared_data_buckets_for_compact_part = '2';

INSERT INTO test_compact_advanced_tuple SELECT tuple(json)
FROM source;

SELECT json.data
FROM test_compact_advanced_tuple;

SELECT
    json.data,
    json.data.b
FROM test_compact_advanced_tuple;

SELECT
    json.data.b,
    json.data
FROM test_compact_advanced_tuple;

SELECT
    json.data,
    json.data.b,
    json.data.c
FROM test_compact_advanced_tuple;

SELECT
    json.data.b,
    json.data,
    json.data.c
FROM test_compact_advanced_tuple;

SELECT
    json.data.b,
    json.data.c,
    json.data
FROM test_compact_advanced_tuple;

SELECT
    json.data,
    json.data.^a
FROM test_compact_advanced_tuple;

SELECT
    json.data.^a,
    json.data
FROM test_compact_advanced_tuple;

SELECT
    json.data,
    json.data.^a,
    json.data.b
FROM test_compact_advanced_tuple;

SELECT
    json.data.b,
    json.data.^a,
    json.data
FROM test_compact_advanced_tuple;

DROP TABLE test_compact_advanced_tuple;

DROP TABLE source;