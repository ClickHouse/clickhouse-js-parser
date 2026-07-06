-- Tags: no-parallel, no-fasttest
-- Tag no-fasttest: Depends on AWS
-- { echo }
DROP TABLE IF EXISTS test_02480_support_wildcard_write;

DROP TABLE IF EXISTS test_02480_support_wildcard_write2;

CREATE TABLE test_02480_support_wildcard_write
(
    a UInt64,
    b String
)
ENGINE = S3(s3_conn, filename = 'test_02480_support_wildcard_{_partition_id}', `format` = Parquet)
PARTITION BY a;

SET s3_truncate_on_insert = '1';

INSERT INTO test_02480_support_wildcard_write;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'test_02480_support_wildcard_*', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'test_02480_support_wildcard_?', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'test_02480_support_wildcard_??', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'test_02480_support_wildcard_?*?', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'test_02480_support_wildcard_{1,333}', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'test_02480_support_wildcard_{1..333}', `format` = Parquet)
ORDER BY a ASC;

CREATE TABLE test_02480_support_wildcard_write2
(
    a UInt64,
    b String
)
ENGINE = S3(s3_conn, filename = 'prefix/test_02480_support_wildcard_{_partition_id}', `format` = Parquet)
PARTITION BY a;

INSERT INTO test_02480_support_wildcard_write2;

SELECT
    a,
    b
FROM s3(s3_conn, filename = '*/test_02480_support_wildcard_*', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = '*/test_02480_support_wildcard_?', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'prefix/test_02480_support_wildcard_??', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'prefi?/test_02480_support_wildcard_*', `format` = Parquet)
ORDER BY a ASC;

SELECT
    a,
    b
FROM s3(s3_conn, filename = 'p?*/test_02480_support_wildcard_{56..666}', `format` = Parquet)
ORDER BY a ASC;

DROP TABLE test_02480_support_wildcard_write;

DROP TABLE test_02480_support_wildcard_write2;