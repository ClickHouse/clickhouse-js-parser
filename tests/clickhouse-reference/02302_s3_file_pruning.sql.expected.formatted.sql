-- Tags: no-parallel, no-fasttest
-- Tag no-fasttest: Depends on S3
SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

-- { echo }
DROP TABLE IF EXISTS test_02302;

CREATE TABLE test_02302
(
    a UInt64
)
ENGINE = S3(s3_conn, filename = 'test_02302_{_partition_id}', `format` = Parquet)
PARTITION BY a;

INSERT INTO test_02302 SELECT number
FROM numbers(10)
SETTINGS s3_truncate_on_insert = '1';

SELECT *
FROM test_02302; -- { serverError NOT_IMPLEMENTED }

DROP TABLE test_02302;

SET max_rows_to_read = '1';

-- Test s3 table function with glob
SELECT *
FROM s3(s3_conn, filename = 'test_02302_*', `format` = Parquet)
WHERE _file LIKE '%5';

CREATE TABLE test_02302
(
    a UInt64
)
ENGINE = S3(s3_conn, filename = 'test_02302.2', `format` = Parquet);

TRUNCATE TABLE test_02302;

CREATE TABLE test_02302
(
    a UInt64
)
ENGINE = S3(s3_conn, filename = 'test_02302.1', `format` = Parquet);

CREATE TABLE test_02302
(
    a UInt64
)
ENGINE = S3(s3_conn, filename = 'test_02302', `format` = Parquet);

INSERT INTO test_02302 SELECT 0
SETTINGS s3_create_new_file_on_insert = true;

INSERT INTO test_02302 SELECT 1
SETTINGS s3_create_new_file_on_insert = true;

INSERT INTO test_02302 SELECT 2
SETTINGS s3_create_new_file_on_insert = true;

SELECT *
FROM test_02302
WHERE _file LIKE '%1';

SELECT
    _file,
    *
FROM test_02302
WHERE _file LIKE '%1';

SET max_rows_to_read = '2';

SELECT *
FROM test_02302
WHERE (_file LIKE '%.1'
    OR _file LIKE '%.2')
    AND a > 1;

SET max_rows_to_read = '999';

SELECT
    'a1' AS _file,
    *
FROM test_02302
WHERE _file LIKE '%1'
ORDER BY a ASC;