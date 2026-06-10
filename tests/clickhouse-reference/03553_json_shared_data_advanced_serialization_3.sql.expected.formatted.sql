-- Tags: long, no-azure-blob-storage
SET output_format_json_quote_64bit_integers = '0';

DROP TABLE IF EXISTS source;

CREATE TABLE source
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = Memory();

INSERT INTO source FORMAT JSONAsObject;

DROP TABLE IF EXISTS test_wide_advanced;

CREATE TABLE test_wide_advanced
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'advanced', object_shared_data_serialization_version_for_zero_level_parts = 'advanced', object_shared_data_buckets_for_wide_part = '2';

INSERT INTO test_wide_advanced SELECT *
FROM source;

SELECT json
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT json.b
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.b,
    json.c
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr2
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr.:`Array(JSON)`.arr2,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr4
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr.:`Array(JSON)`.arr4,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr.:`Array(JSON)`.arr99
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr.:`Array(JSON)`.arr99,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.arr
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json,
    json.b,
    json.c
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.b,
    json.c,
    json
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json,
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1,
    json
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json,
    json.b,
    json.c,
    json.arr,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.b,
    json.c,
    json.arr.:`Array(JSON)`.arr1,
    json.arr,
    json
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT json.^a
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json,
    json.^a
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.^a,
    json.a.a1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.a.a1,
    json.^a
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.^a,
    json
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.arr.:`Array(JSON)`.arr1,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json.arr.:`Array(JSON)`.arr1
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json,
    json.arr.:`Array(JSON)`.arr1,
    json.^a,
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr
FROM test_wide_advanced
SETTINGS max_block_size = '3';

SELECT
    json.a.a1,
    json.a.arr.:`Array(JSON)`.arr1,
    json.b,
    json.arr,
    json.^a,
    json.arr.:`Array(JSON)`.arr1,
    json
FROM test_wide_advanced
SETTINGS max_block_size = '3';

DROP TABLE test_wide_advanced;

DROP TABLE source;