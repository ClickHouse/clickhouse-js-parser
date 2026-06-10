-- Tags: no-fasttest, no-parallel
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    number UInt64
)
ENGINE = File('Parquet');

INSERT INTO test SELECT *
FROM numbers(10);

INSERT INTO test SELECT *
FROM numbers(10, 10); -- { serverError CANNOT_APPEND_TO_FILE }

INSERT INTO test SELECT *
FROM numbers(10, 10)
SETTINGS engine_file_allow_create_multiple_files = '1';

SELECT *
FROM test
ORDER BY number ASC;

TRUNCATE TABLE test;

DROP TABLE test;

CREATE TABLE test
(
    number UInt64
)
ENGINE = File('Parquet', 'test_02155/test1/data.Parquet');

INSERT INTO test SELECT *
FROM numbers(10)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(concat(currentDatabase(), '/test2/data.Parquet'), 'Parquet', 'number UInt64') SELECT *
FROM numbers(10)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(concat(currentDatabase(), '/test2/data.Parquet'), 'Parquet', 'number UInt64') SELECT *
FROM numbers(10, 10); -- { serverError CANNOT_APPEND_TO_FILE }

INSERT INTO FUNCTION file(concat(currentDatabase(), '/test2/data.Parquet'), 'Parquet', 'number UInt64') SELECT *
FROM numbers(10, 10)
SETTINGS engine_file_allow_create_multiple_files = '1';

SELECT *
FROM file(concat(currentDatabase(), '/test2/data.Parquet'), 'Parquet', 'number UInt64');

SELECT *
FROM file(concat(currentDatabase(), '/test2/data.1.Parquet'), 'Parquet', 'number UInt64');

CREATE TABLE test
(
    number UInt64
)
ENGINE = File('Parquet', 'test_02155/test3/data.Parquet.gz');

;

INSERT INTO FUNCTION file(concat(currentDatabase(), '/test4/data.Parquet.gz'), 'Parquet', 'number UInt64') SELECT *
FROM numbers(10)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(concat(currentDatabase(), '/test4/data.Parquet.gz'), 'Parquet', 'number UInt64') SELECT *
FROM numbers(10, 10); -- { serverError CANNOT_APPEND_TO_FILE }

INSERT INTO FUNCTION file(concat(currentDatabase(), '/test4/data.Parquet.gz'), 'Parquet', 'number UInt64') SELECT *
FROM numbers(10, 10)
SETTINGS engine_file_allow_create_multiple_files = '1';

SELECT *
FROM file(concat(currentDatabase(), '/test4/data.Parquet.gz'), 'Parquet', 'number UInt64');

SELECT *
FROM file(concat(currentDatabase(), '/test4/data.1.Parquet.gz'), 'Parquet', 'number UInt64');