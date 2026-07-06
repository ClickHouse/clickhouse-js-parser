SET enable_analyzer = '1';

DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    id UInt64,
    value String,
    value_array Array(UInt64),
    value_array_array Array(Array(UInt64))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_table;

SELECT
    id,
    value,
    value_1
FROM
    test_table
ARRAY JOIN [1, 2, 3] AS value_1;

SELECT '--';

SELECT
    id,
    value
FROM
    test_table
ARRAY JOIN [1, 2, 3] AS value;

WITH [1, 2, 3] AS constant_array

SELECT
    id,
    value
FROM
    test_table
ARRAY JOIN constant_array AS value;

WITH [1, 2, 3] AS constant_array

SELECT
    id,
    value,
    value_1
FROM
    test_table
ARRAY JOIN constant_array AS value_1;

SELECT
    id,
    value,
    value_1,
    value_2
FROM
    test_table
ARRAY JOIN [[1, 2, 3]] AS value_1
ARRAY JOIN value_1 AS value_2;

SELECT 1 AS value
FROM
    test_table
ARRAY JOIN [1, 2, 3] AS value;

SELECT
    id,
    value,
    test_table.value_array
FROM
    test_table
ARRAY JOIN value_array;

SELECT
    id,
    value_array,
    value
FROM
    test_table
ARRAY JOIN value_array AS value;

SELECT
    id,
    value,
    value_array,
    value_array_element
FROM
    test_table
ARRAY JOIN value_array AS value_array_element;

SELECT
    id,
    value,
    value_array AS value_array_array_alias
FROM
    test_table
ARRAY JOIN value_array_array_alias;

SELECT id AS value
FROM
    test_table
ARRAY JOIN value_array AS value;

SELECT
    id,
    value,
    value_array AS value_array_array_alias,
    value_array_array_alias_element
FROM
    test_table
ARRAY JOIN value_array_array_alias AS value_array_array_alias_element;

SELECT
    id,
    value,
    value_array_array,
    value_array_array_inner_element,
    value_array_array_inner_element,
    value_array_array_inner_inner_element
FROM
    test_table
ARRAY JOIN value_array_array AS value_array_array_inner_element
ARRAY JOIN value_array_array_inner_element AS value_array_array_inner_inner_element;

SELECT 1
FROM
    `system`.one
ARRAY JOIN arrayMap((x -> ignore(*)), []);

SELECT arrayFilter((x -> notEmpty(concat(x, 'hello'))), [''])
FROM
    `system`.one
ARRAY JOIN [0] AS elem, arrayMap((x -> concat(x, ignore(ignore(toLowCardinality('03147_parquet_memory_tracking.parquet'), 37, 37, toUInt128(37), 37, 37, toLowCardinality(37), 37), 8, ignore(ignore(1., 36, 8, 8)), *), 'hello')), ['']) AS unused
WHERE NOT ignore(elem)
GROUP BY
    sum(ignore(ignore(ignore(1., 1, 36, 8, 8), ignore(52, 37, 37, '03147_parquet_memory_tracking.parquet', 37, 37, toUInt256(37), 37, 37, toNullable(37), 37, 37), 1., 1, 36, 8, 8), emptyArrayToSingle(arrayMap((x -> toString(x)), arrayMap((x -> nullIf(x, 2)), arrayJoin([[1]])))))) IGNORE NULLS,
    modulo(toLowCardinality('03147_parquet_memory_tracking.parquet'), number, toLowCardinality(3)); -- { serverError UNKNOWN_IDENTIFIER }

-- { echoOff }
DROP TABLE test_table;

SELECT
    [1, 2] AS arr,
    x
FROM
    `system`.one
ARRAY JOIN arr AS x;

SELECT x + 1 AS x
FROM
    (
        SELECT [number] AS arr
        FROM numbers(2)
    ) AS s
ARRAY JOIN arr AS x;