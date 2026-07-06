DROP TABLE IF EXISTS test_table;

DROP TABLE IF EXISTS test_table_2;

SET input_format_null_as_default = '0';

SELECT 1;

/* Check JSONCompactEachRow Output */
CREATE TABLE test_table
(
    value UInt8,
    name String
)
ENGINE = MergeTree()
ORDER BY value;

INSERT INTO test_table;

SELECT *
FROM test_table
FORMAT JSONCompactEachRow;

SELECT 2;

/* Check Totals */
SELECT
    name,
    count() AS c
FROM test_table
GROUP BY name
WITH TOTALS
ORDER BY name ASC
FORMAT JSONCompactEachRow;

SELECT 3;

/* Check JSONCompactEachRowWithNames and JSONCompactEachRowWithNamesAndTypes Output */
SELECT *
FROM test_table
FORMAT JSONCompactEachRowWithNamesAndTypes;

SELECT '----------';

SELECT *
FROM test_table
FORMAT JSONCompactEachRowWithNames;

SELECT 4;

/* Check Totals */
SELECT
    name,
    count() AS c
FROM test_table
GROUP BY name
WITH TOTALS
ORDER BY name ASC
FORMAT JSONCompactEachRowWithNamesAndTypes;

SELECT 5;

/* Check JSONCompactEachRow Input */
CREATE TABLE test_table
(
    v1 String,
    v2 UInt8,
    v3 DEFAULT v2 * 16,
    v4 UInt8 DEFAULT 8
)
ENGINE = MergeTree()
ORDER BY v2;

INSERT INTO test_table FORMAT JSONCompactEachRow;

TRUNCATE TABLE test_table;

SELECT 6;

/* Check input_format_null_as_default = 1 */
SET input_format_null_as_default = '1';

SELECT 7;

/* Check Nested */
CREATE TABLE test_table_2
(
    v1 UInt8,
    n Nested(id UInt8, name String)
)
ENGINE = MergeTree()
ORDER BY v1;

INSERT INTO test_table_2 FORMAT JSONCompactEachRow;

SELECT *
FROM test_table_2
FORMAT JSONCompactEachRow;

TRUNCATE TABLE test_table_2;

SELECT 8;

INSERT INTO test_table FORMAT JSONCompactEachRowWithNamesAndTypes;

INSERT INTO test_table FORMAT JSONCompactEachRowWithNames;

SELECT 9;

INSERT INTO test_table FORMAT JSONCompactEachRowWithNamesAndTypes;

INSERT INTO test_table FORMAT JSONCompactEachRowWithNames;

SELECT 10;

SET input_format_skip_unknown_fields = '1';

INSERT INTO test_table FORMAT JSONCompactEachRowWithNamesAndTypes;

INSERT INTO test_table FORMAT JSONCompactEachRowWithNames;

SELECT 11;

INSERT INTO test_table FORMAT JSONCompactEachRowWithNamesAndTypes;

SELECT 12;

/* Check Nested */
INSERT INTO test_table_2 FORMAT JSONCompactEachRowWithNamesAndTypes;

INSERT INTO test_table_2 FORMAT JSONCompactEachRowWithNames;

SELECT *
FROM test_table_2
FORMAT JSONCompactEachRowWithNamesAndTypes;

SELECT *
FROM test_table_2
FORMAT JSONCompactEachRowWithNames;