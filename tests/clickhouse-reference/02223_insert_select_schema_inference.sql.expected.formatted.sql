DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt32,
    y String,
    d Date
)
ENGINE = Memory() AS
SELECT
    number AS x,
    toString(number) AS y,
    toDate(number) AS d
FROM numbers(10);

INSERT INTO FUNCTION file('data.native.zst') SELECT *
FROM test
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file('data.native.zst');

SELECT *
FROM file('data.native.zst');