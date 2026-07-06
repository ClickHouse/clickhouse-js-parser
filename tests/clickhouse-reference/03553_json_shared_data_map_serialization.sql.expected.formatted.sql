SET output_format_json_quote_64bit_integers = '0';

DROP TABLE IF EXISTS source;

CREATE TABLE source
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = Memory();

INSERT INTO source FORMAT JSONAsObject;

DROP TABLE IF EXISTS test_compact_map;

CREATE TABLE test_compact_map
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '200G', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'map', object_shared_data_serialization_version_for_zero_level_parts = 'map';

INSERT INTO test_compact_map SELECT *
FROM source;

SELECT json
FROM test_compact_map;

SELECT json.b
FROM test_compact_map;

SELECT
    json.b,
    json.c
FROM test_compact_map;

SELECT
    json,
    json.b,
    json.c
FROM test_compact_map;

SELECT
    json.b,
    json.c,
    json
FROM test_compact_map;

SELECT json.^a
FROM test_compact_map;

SELECT
    json,
    json.^a
FROM test_compact_map;

SELECT
    json.^a,
    json.a.a1
FROM test_compact_map;

SELECT
    json.a.a1,
    json.^a
FROM test_compact_map;

DROP TABLE test_compact_map;

DROP TABLE IF EXISTS test_compact_map_tuple;

CREATE TABLE test_compact_map_tuple
(
    json Tuple(data JSON(max_dynamic_paths = 8))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '200G', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'map', object_shared_data_serialization_version_for_zero_level_parts = 'map';

INSERT INTO test_compact_map_tuple SELECT tuple(json)
FROM source;

SELECT json.data
FROM test_compact_map_tuple;

SELECT
    json.data,
    json.data.b
FROM test_compact_map_tuple;

SELECT
    json.data.b,
    json.data
FROM test_compact_map_tuple;

SELECT
    json.data,
    json.data.b,
    json.data.c
FROM test_compact_map_tuple;

SELECT
    json.data.b,
    json.data,
    json.data.c
FROM test_compact_map_tuple;

SELECT
    json.data.b,
    json.data.c,
    json.data
FROM test_compact_map_tuple;

SELECT
    json.data,
    json.data.^a
FROM test_compact_map_tuple;

SELECT
    json.data.^a,
    json.data
FROM test_compact_map_tuple;

SELECT
    json.data,
    json.data.^a,
    json.data.b
FROM test_compact_map_tuple;

SELECT
    json.data.b,
    json.data.^a,
    json.data
FROM test_compact_map_tuple;

DROP TABLE test_compact_map_tuple;

DROP TABLE IF EXISTS test_wide_map;

CREATE TABLE test_wide_map
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'map', object_shared_data_serialization_version_for_zero_level_parts = 'map';

INSERT INTO test_wide_map SELECT *
FROM source;

SELECT json
FROM test_wide_map;

SELECT json.b
FROM test_wide_map;

SELECT
    json.b,
    json.c
FROM test_wide_map;

SELECT
    json,
    json.b,
    json.c
FROM test_wide_map;

SELECT
    json.b,
    json.c,
    json
FROM test_wide_map;

SELECT json.^a
FROM test_wide_map;

SELECT
    json,
    json.^a
FROM test_wide_map;

SELECT
    json.^a,
    json.a.a1
FROM test_wide_map;

SELECT
    json.a.a1,
    json.^a
FROM test_wide_map;

SELECT json
FROM test_wide_map
LIMIT 3;

SELECT json.b
FROM test_wide_map
LIMIT 3;

SELECT
    json.b,
    json.c
FROM test_wide_map
LIMIT 3;

SELECT
    json,
    json.b,
    json.c
FROM test_wide_map
LIMIT 3;

SELECT
    json.b,
    json.c,
    json
FROM test_wide_map
LIMIT 3;

SELECT json.^a
FROM test_wide_map
LIMIT 3;

SELECT
    json,
    json.^a
FROM test_wide_map
LIMIT 3;

SELECT
    json.^a,
    json.a.a1
FROM test_wide_map
LIMIT 3;

SELECT
    json.a.a1,
    json.^a
FROM test_wide_map
LIMIT 3;

SELECT json
FROM test_wide_map
SETTINGS max_block_size = '3';

SELECT json.b
FROM test_wide_map
SETTINGS max_block_size = '3';

SELECT
    json.b,
    json.c
FROM test_wide_map
SETTINGS max_block_size = '3';

SELECT
    json,
    json.b,
    json.c
FROM test_wide_map
SETTINGS max_block_size = '3';

SELECT
    json.b,
    json.c,
    json
FROM test_wide_map
SETTINGS max_block_size = '3';

SELECT json.^a
FROM test_wide_map
SETTINGS max_block_size = '3';

SELECT
    json,
    json.^a
FROM test_wide_map
SETTINGS max_block_size = '3';

SELECT
    json.^a,
    json.a.a1
FROM test_wide_map
SETTINGS max_block_size = '3';

SELECT
    json.a.a1,
    json.^a
FROM test_wide_map
SETTINGS max_block_size = '3';

DROP TABLE test_wide_map;

DROP TABLE IF EXISTS test_wide_map_tuple;

CREATE TABLE test_wide_map_tuple
(
    json Tuple(data JSON(max_dynamic_paths = 8))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '2', min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1', write_marks_for_substreams_in_compact_parts = '1', object_serialization_version = 'v3', object_shared_data_serialization_version = 'map', object_shared_data_serialization_version_for_zero_level_parts = 'map';

INSERT INTO test_wide_map_tuple SELECT tuple(json)
FROM source;

SELECT json.data
FROM test_wide_map_tuple;

SELECT
    json.data,
    json.data.b
FROM test_wide_map_tuple;

SELECT
    json.data.b,
    json.data
FROM test_wide_map_tuple;

SELECT
    json.data,
    json.data.b,
    json.data.c
FROM test_wide_map_tuple;

SELECT
    json.data.b,
    json.data,
    json.data.c
FROM test_wide_map_tuple;

SELECT
    json.data.b,
    json.data.c,
    json.data
FROM test_wide_map_tuple;

SELECT
    json.data,
    json.data.^a
FROM test_wide_map_tuple;

SELECT
    json.data.^a,
    json.data
FROM test_wide_map_tuple;

SELECT
    json.data,
    json.data.^a,
    json.data.b
FROM test_wide_map_tuple;

SELECT
    json.data.b,
    json.data.^a,
    json.data
FROM test_wide_map_tuple;

SELECT json.data
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data,
    json.data.b
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data.b,
    json.data
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data,
    json.data.b,
    json.data.c
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data.b,
    json.data,
    json.data.c
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data.b,
    json.data.c,
    json.data
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data,
    json.data.^a
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data.^a,
    json.data
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data,
    json.data.^a,
    json.data.b
FROM test_wide_map_tuple
LIMIT 3;

SELECT
    json.data.b,
    json.data.^a,
    json.data
FROM test_wide_map_tuple
LIMIT 3;

SELECT json.data
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data,
    json.data.b
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.b,
    json.data
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data,
    json.data.b,
    json.data.c
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.b,
    json.data,
    json.data.c
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.b,
    json.data.c,
    json.data
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data,
    json.data.^a
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.^a,
    json.data
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data,
    json.data.^a,
    json.data.b
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

SELECT
    json.data.b,
    json.data.^a,
    json.data
FROM test_wide_map_tuple
SETTINGS max_block_size = '3';

DROP TABLE test_wide_map_tuple;

DROP TABLE source;