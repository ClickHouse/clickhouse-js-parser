-- Tags: no-fasttest
-- Tag no-fasttest: Depends on AWS
-- { echo }
DROP TABLE IF EXISTS test_02245;

CREATE TABLE test_02245
(
    a UInt64
)
ENGINE = S3(s3_conn, filename = 'test_02245', `format` = Parquet);

INSERT INTO test_02245 SELECT 1
SETTINGS s3_truncate_on_insert = '1';

SELECT *
FROM test_02245;

SELECT _path
FROM test_02245;

DROP TABLE IF EXISTS test_02245_2;

CREATE TABLE test_02245_2
(
    a UInt64,
    _path Int32
)
ENGINE = S3(s3_conn, filename = 'test_02245_2', `format` = Parquet);

INSERT INTO test_02245_2 SELECT
    1,
    2
SETTINGS s3_truncate_on_insert = '1';

SELECT *
FROM test_02245_2;

SELECT
    _path,
    isNotNull(_etag)
FROM test_02245_2;

SELECT count()
FROM test_02245_2
WHERE _etag IN (
        SELECT _etag
        FROM test_02245_2
    );