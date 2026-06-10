-- Tags: no-random-merge-tree-settings
-- add_minmax_index_for_numeric_columns=0: Different part size on disk
SET send_logs_level = 'fatal';

SET joined_subquery_requires_alias = '0';

DROP TABLE IF EXISTS delta_codec_synthetic;

DROP TABLE IF EXISTS default_codec_synthetic;

CREATE TABLE delta_codec_synthetic
(
    id UInt64 CODEC(Delta(), ZSTD(3))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0', compress_marks = false, compress_primary_key = false, ratio_of_defaults_for_sparse_serialization = '1', enable_block_number_column = '0', serialization_info_version = 'basic', auto_statistics_types = '', add_minmax_index_for_numeric_columns = '0';

CREATE TABLE default_codec_synthetic
(
    id UInt64 CODEC(ZSTD(3))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0', compress_marks = false, compress_primary_key = false, ratio_of_defaults_for_sparse_serialization = '1', enable_block_number_column = '0', auto_statistics_types = '', add_minmax_index_for_numeric_columns = '0';

SET max_insert_threads = '1';

INSERT INTO delta_codec_synthetic SELECT number
FROM `system`.numbers
LIMIT 5000000;

INSERT INTO default_codec_synthetic SELECT number
FROM `system`.numbers
LIMIT 5000000;

OPTIMIZE TABLE delta_codec_synthetic FINAL;

OPTIMIZE TABLE default_codec_synthetic FINAL;

SELECT floor(big_size / small_size) AS ratio
FROM
    (
        SELECT
            1 AS key,
            sum(bytes_on_disk) AS small_size
        FROM `system`.parts
        WHERE database = currentDatabase()
            AND table = 'delta_codec_synthetic'
            AND active
    )
INNER JOIN (
        SELECT
            1 AS key,
            sum(bytes_on_disk) AS big_size
        FROM `system`.parts
        WHERE database = currentDatabase()
            AND table = 'default_codec_synthetic'
            AND active
    )
    USING (key);

SELECT small_hash = big_hash
FROM
    (
        SELECT
            1 AS key,
            sum(cityHash64(*)) AS small_hash
        FROM delta_codec_synthetic
    )
INNER JOIN (
        SELECT
            1 AS key,
            sum(cityHash64(*)) AS big_hash
        FROM default_codec_synthetic
    )
    USING (key);

DROP TABLE IF EXISTS delta_codec_float;

DROP TABLE IF EXISTS default_codec_float;

CREATE TABLE delta_codec_float
(
    id Float64 CODEC(Delta(), LZ4HC())
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0', compress_marks = false, compress_primary_key = false, ratio_of_defaults_for_sparse_serialization = '1', enable_block_number_column = '0', auto_statistics_types = '', add_minmax_index_for_numeric_columns = '0';

CREATE TABLE default_codec_float
(
    id Float64 CODEC(LZ4HC())
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0', compress_marks = false, compress_primary_key = false, ratio_of_defaults_for_sparse_serialization = '1', enable_block_number_column = '0', auto_statistics_types = '', add_minmax_index_for_numeric_columns = '0';

INSERT INTO delta_codec_float SELECT number
FROM numbers(1547510400, 500000)
WHERE number % 3 = 0
    OR number % 5 = 0
    OR number % 7 = 0
    OR number % 11 = 0;

INSERT INTO default_codec_float SELECT *
FROM delta_codec_float;

OPTIMIZE TABLE delta_codec_float FINAL;

OPTIMIZE TABLE default_codec_float FINAL;

SELECT floor(big_size / small_size) AS ratio
FROM
    (
        SELECT
            1 AS key,
            sum(bytes_on_disk) AS small_size
        FROM `system`.parts
        WHERE database = currentDatabase()
            AND table = 'delta_codec_float'
            AND active
    )
INNER JOIN (
        SELECT
            1 AS key,
            sum(bytes_on_disk) AS big_size
        FROM `system`.parts
        WHERE database = currentDatabase()
            AND table = 'default_codec_float'
            AND active
    )
    USING (key);

SELECT small_hash = big_hash
FROM
    (
        SELECT
            1 AS key,
            sum(cityHash64(*)) AS small_hash
        FROM delta_codec_float
    )
INNER JOIN (
        SELECT
            1 AS key,
            sum(cityHash64(*)) AS big_hash
        FROM default_codec_float
    )
    USING (key);

DROP TABLE IF EXISTS delta_codec_string;

DROP TABLE IF EXISTS default_codec_string;

CREATE TABLE delta_codec_string
(
    id Float64 CODEC(Delta(), LZ4())
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0', compress_marks = false, compress_primary_key = false, ratio_of_defaults_for_sparse_serialization = '1', enable_block_number_column = '0', auto_statistics_types = '', add_minmax_index_for_numeric_columns = '0';

CREATE TABLE default_codec_string
(
    id Float64 CODEC(LZ4())
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0', compress_marks = false, compress_primary_key = false, ratio_of_defaults_for_sparse_serialization = '1', enable_block_number_column = '0', auto_statistics_types = '', add_minmax_index_for_numeric_columns = '0';

INSERT INTO delta_codec_string SELECT concat(toString(number), toString(number % 100))
FROM numbers(1547510400, 500000);

INSERT INTO default_codec_string SELECT *
FROM delta_codec_string;

OPTIMIZE TABLE delta_codec_string FINAL;

OPTIMIZE TABLE default_codec_string FINAL;

SELECT floor(big_size / small_size) AS ratio
FROM
    (
        SELECT
            1 AS key,
            sum(bytes_on_disk) AS small_size
        FROM `system`.parts
        WHERE database = currentDatabase()
            AND table = 'delta_codec_string'
            AND active
    )
INNER JOIN (
        SELECT
            1 AS key,
            sum(bytes_on_disk) AS big_size
        FROM `system`.parts
        WHERE database = currentDatabase()
            AND table = 'default_codec_string'
            AND active
    )
    USING (key);

SELECT small_hash = big_hash
FROM
    (
        SELECT
            1 AS key,
            sum(cityHash64(*)) AS small_hash
        FROM delta_codec_string
    )
INNER JOIN (
        SELECT
            1 AS key,
            sum(cityHash64(*)) AS big_hash
        FROM default_codec_string
    )
    USING (key);