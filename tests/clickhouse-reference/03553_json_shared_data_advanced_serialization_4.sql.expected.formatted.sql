-- Tags: long, no-azure-blob-storage
SET output_format_json_quote_64bit_integers = '0';

DROP TABLE IF EXISTS source;

CREATE TABLE source
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = Memory();

INSERT INTO source FORMAT JSONAsObject;

DROP TABLE IF EXISTS test_wide_advanced_tuple;

CREATE TABLE test_wide_advanced_tuple
(
    json Tuple(data JSON(max_dynamic_paths = 8))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'advanced', object_shared_data_serialization_version_for_zero_level_parts = 'advanced', object_shared_data_buckets_for_wide_part = '2';

INSERT INTO test_wide_advanced_tuple SELECT tuple(json)
FROM source;

SELECT json.data
FROM test_wide_advanced_tuple;

SELECT
    json.data,
    json.data.b
FROM test_wide_advanced_tuple;

SELECT
    json.data.b,
    json.data
FROM test_wide_advanced_tuple;

SELECT
    json.data,
    json.data.b,
    json.data.c
FROM test_wide_advanced_tuple;

SELECT
    json.data.b,
    json.data,
    json.data.c
FROM test_wide_advanced_tuple;

SELECT
    json.data.b,
    json.data.c,
    json.data
FROM test_wide_advanced_tuple;

SELECT
    json.data,
    json.data.^a
FROM test_wide_advanced_tuple;

SELECT
    json.data.^a,
    json.data
FROM test_wide_advanced_tuple;

SELECT
    json.data,
    json.data.^a,
    json.data.b
FROM test_wide_advanced_tuple;

SELECT
    json.data.b,
    json.data.^a,
    json.data
FROM test_wide_advanced_tuple;

SELECT json.data
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data,
    json.data.b
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data.b,
    json.data
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data,
    json.data.b,
    json.data.c
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data.b,
    json.data,
    json.data.c
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data.b,
    json.data.c,
    json.data
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data,
    json.data.^a
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data.^a,
    json.data
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data,
    json.data.^a,
    json.data.b
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT
    json.data.b,
    json.data.^a,
    json.data
FROM test_wide_advanced_tuple
LIMIT 3;

SELECT json.data
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data,
    json.data.b
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.b,
    json.data
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data,
    json.data.b,
    json.data.c
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.b,
    json.data,
    json.data.c
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.b,
    json.data.c,
    json.data
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data,
    json.data.^a
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.^a,
    json.data
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data,
    json.data.^a,
    json.data.b
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.b,
    json.data.^a,
    json.data
FROM test_wide_advanced_tuple
SETTINGS max_block_size = '3';

DROP TABLE test_wide_advanced_tuple;

DROP TABLE source;