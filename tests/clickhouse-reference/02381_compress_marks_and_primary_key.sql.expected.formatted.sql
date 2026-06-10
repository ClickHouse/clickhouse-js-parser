-- Tags: no-random-merge-tree-settings
-- add_minmax_index_for_numeric_columns=0: Different sizes
SET optimize_trivial_insert_select = '1';

DROP TABLE IF EXISTS test_02381;

CREATE TABLE test_02381
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS compress_marks = false, compress_primary_key = false, ratio_of_defaults_for_sparse_serialization = '1', serialization_info_version = 'basic', auto_statistics_types = '', add_minmax_index_for_numeric_columns = '0';

INSERT INTO test_02381 SELECT
    number,
    number * 10
FROM `system`.numbers
LIMIT 1000000;

DROP TABLE IF EXISTS test_02381_compress;

CREATE TABLE test_02381_compress
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS compress_marks = true, compress_primary_key = true, marks_compression_codec = 'ZSTD(3)', primary_key_compression_codec = 'ZSTD(3)', marks_compress_block_size = '65536', primary_key_compress_block_size = '65536', ratio_of_defaults_for_sparse_serialization = '1', serialization_info_version = 'basic', auto_statistics_types = '', add_minmax_index_for_numeric_columns = '0';

INSERT INTO test_02381_compress SELECT
    number,
    number * 10
FROM `system`.numbers
LIMIT 1000000;

SELECT *
FROM test_02381_compress
WHERE a = 1000
LIMIT 1;

OPTIMIZE TABLE test_02381_compress FINAL;

-- Compare the size of marks on disk
SELECT
    table,
    sum(`rows`),
    sum(bytes_on_disk) AS sum_bytes,
    sum(marks_bytes) AS sum_marks_bytes,
    sum_bytes - sum_marks_bytes AS exclude_marks
FROM `system`.parts_columns
WHERE active
    AND database = currentDatabase()
    AND table LIKE 'test_02381%'
GROUP BY table
ORDER BY table ASC;

-- Switch to compressed and uncompressed
-- Test wide part
ALTER TABLE test_02381 MODIFY SETTING compress_marks = true, compress_primary_key = true;

ALTER TABLE test_02381_compress MODIFY SETTING compress_marks = false, compress_primary_key = false;

SELECT *
FROM test_02381_compress
WHERE a = 10000
LIMIT 1;

SELECT *
FROM test_02381
WHERE a = 10000
LIMIT 1;

OPTIMIZE TABLE test_02381 FINAL;

-- Test compact part
DROP TABLE IF EXISTS test_02381_compact;

CREATE TABLE test_02381_compact
(
    a UInt64,
    b String
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS auto_statistics_types = '';

INSERT INTO test_02381_compact;

ALTER TABLE test_02381_compact MODIFY SETTING compress_marks = true, compress_primary_key = true;

INSERT INTO test_02381_compact;

SELECT *
FROM test_02381_compact
ORDER BY a ASC;

OPTIMIZE TABLE test_02381_compact FINAL;