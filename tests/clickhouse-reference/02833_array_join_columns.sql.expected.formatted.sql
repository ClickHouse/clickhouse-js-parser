DROP TABLE IF EXISTS test_array_joins;

DROP TABLE IF EXISTS v4test_array_joins;

CREATE TABLE test_array_joins
(
    id UInt64 DEFAULT rowNumberInAllBlocks() + 1,
    arr_1 Array(String),
    arr_2 Array(String),
    arr_3 Array(String),
    arr_4 Array(String)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_array_joins (id, arr_1, arr_2, arr_3, arr_4) SELECT
    number,
    array(randomPrintableASCII(3)),
    array(randomPrintableASCII(3)),
    array(randomPrintableASCII(3)),
    array(randomPrintableASCII(3))
FROM numbers(1000);

CREATE VIEW v4test_array_joins
AS
SELECT *
FROM test_array_joins
WHERE id != 10;

SELECT *
FROM
    v4test_array_joins
ARRAY JOIN COLUMNS('^arr')
WHERE match(arr_4, 'a')
    AND id < 100
ORDER BY id ASC
FORMAT Null
SETTINGS optimize_read_in_order = '0';