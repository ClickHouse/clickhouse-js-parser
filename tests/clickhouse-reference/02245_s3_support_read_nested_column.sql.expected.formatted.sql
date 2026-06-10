-- Tags: no-fasttest
-- Tag no-fasttest: Depends on AWS
-- { echo }
DROP TABLE IF EXISTS test_02245_s3_nested_parquet1;

DROP TABLE IF EXISTS test_02245_s3_nested_parquet2;

SET input_format_parquet_import_nested = '1';

SET s3_truncate_on_insert = '1';

CREATE TABLE test_02245_s3_nested_parquet1
(
    a Int64,
    b Tuple(a Int64, b String)
)
ENGINE = S3(s3_conn, filename = 'test_02245_s3_nested_parquet1_{_partition_id}', `format` = 'Parquet')
PARTITION BY a;

INSERT INTO test_02245_s3_nested_parquet1;

SELECT
    a,
    b.a,
    b.b
FROM s3(s3_conn, filename = 'test_02245_s3_nested_parquet1_*', `format` = 'Parquet');

CREATE TABLE test_02245_s3_nested_parquet2
(
    a Int64,
    b Tuple(a Int64, b Tuple(c Int64, d String))
)
ENGINE = S3(s3_conn, filename = 'test_02245_s3_nested_parquet2_{_partition_id}', `format` = 'Parquet')
PARTITION BY a;

INSERT INTO test_02245_s3_nested_parquet2;

SELECT
    a,
    b.a,
    b.b.c,
    b.b.d
FROM s3(s3_conn, filename = 'test_02245_s3_nested_parquet2_*', `format` = 'Parquet', structure = 'a Int64, b Tuple(a Int64, b Tuple(c Int64, d String))');

DROP TABLE IF EXISTS test_02245_s3_nested_arrow1;

DROP TABLE IF EXISTS test_02245_s3_nested_arrow2;

SET input_format_arrow_import_nested = '1';

CREATE TABLE test_02245_s3_nested_arrow1
(
    a Int64,
    b Tuple(a Int64, b String)
)
ENGINE = S3(s3_conn, filename = 'test_02245_s3_nested_arrow1_{_partition_id}', `format` = 'Arrow')
PARTITION BY a;

INSERT INTO test_02245_s3_nested_arrow1;

SELECT
    a,
    b.a,
    b.b
FROM s3(s3_conn, filename = 'test_02245_s3_nested_arrow1_*', `format` = 'Arrow');

CREATE TABLE test_02245_s3_nested_arrow2
(
    a Int64,
    b Tuple(a Int64, b Tuple(c Int64, d String))
)
ENGINE = S3(s3_conn, filename = 'test_02245_s3_nested_arrow2_{_partition_id}', `format` = 'Arrow')
PARTITION BY a;

INSERT INTO test_02245_s3_nested_arrow2;

SELECT
    a,
    b.a,
    b.b.c,
    b.b.d
FROM s3(s3_conn, filename = 'test_02245_s3_nested_arrow2_*', `format` = 'Arrow', structure = 'a Int64, b Tuple(a Int64, b Tuple(c Int64, d String))');

DROP TABLE IF EXISTS test_02245_s3_nested_orc1;

DROP TABLE IF EXISTS test_02245_s3_nested_orc2;

SET input_format_orc_import_nested = '1';

CREATE TABLE test_02245_s3_nested_orc1
(
    a Int64,
    b Tuple(a Int64, b String)
)
ENGINE = S3(s3_conn, filename = 'test_02245_s3_nested_orc1_{_partition_id}', `format` = 'ORC')
PARTITION BY a;

INSERT INTO test_02245_s3_nested_orc1;

SELECT
    a,
    b.a,
    b.b
FROM s3(s3_conn, filename = 'test_02245_s3_nested_orc1_*', `format` = 'ORC');

CREATE TABLE test_02245_s3_nested_orc2
(
    a Int64,
    b Tuple(a Int64, b Tuple(c Int64, d String))
)
ENGINE = S3(s3_conn, filename = 'test_02245_s3_nested_orc2_{_partition_id}', `format` = 'ORC')
PARTITION BY a;

INSERT INTO test_02245_s3_nested_orc2;

SELECT
    a,
    b.a,
    b.b.c,
    b.b.d
FROM s3(s3_conn, filename = 'test_02245_s3_nested_orc2_*', `format` = 'ORC', structure = 'a Int64, b Tuple(a Int64, b Tuple(c Int64, d String))');