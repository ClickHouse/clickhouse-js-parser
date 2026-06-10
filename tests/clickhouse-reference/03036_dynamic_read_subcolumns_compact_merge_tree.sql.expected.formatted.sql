-- Tags: long, no-tsan, no-msan, no-ubsan, no-asan
-- Random settings limits: index_granularity=(100, None)
SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SET allow_experimental_dynamic_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id UInt64,
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_rows_for_wide_part = '1000000000', min_bytes_for_wide_part = '10000000000';

INSERT INTO test SELECT
    number,
    number
FROM numbers(100000)
SETTINGS min_insert_block_size_rows = '50000';

INSERT INTO test SELECT
    number,
    'str_' || toString(number)
FROM numbers(100000, 100000)
SETTINGS min_insert_block_size_rows = '50000';

INSERT INTO test SELECT
    number,
    arrayMap((x -> multiIf(number % 9 = 0, NULL, number % 9 = 3, 'str_' || toString(number), number)), range(number % 10 + 1))
FROM numbers(200000, 100000)
SETTINGS min_insert_block_size_rows = '50000';

INSERT INTO test SELECT
    number,
    NULL
FROM numbers(300000, 100000)
SETTINGS min_insert_block_size_rows = '50000';

INSERT INTO test SELECT
    number,
    multiIf(number % 4 = 3, 'str_' || toString(number), number % 4 = 2, NULL, number % 4 = 1, number, arrayMap((x -> multiIf(number % 9 = 0, NULL, number % 9 = 3, 'str_' || toString(number), number)), range(number % 10 + 1)))
FROM numbers(400000, 400000)
SETTINGS min_insert_block_size_rows = '50000';

INSERT INTO test SELECT
    number,
    [range((number % 10 + 1)::UInt64)]::Array(Array(Dynamic))
FROM numbers(100000, 100000)
SETTINGS min_insert_block_size_rows = '50000';

SELECT DISTINCT dynamicType(d) AS type
FROM test
ORDER BY type ASC;

SELECT count()
FROM test
WHERE dynamicType(d) = 'UInt64';

SELECT count()
FROM test
WHERE d.UInt64 IS NOT NULL;

SELECT count()
FROM test
WHERE dynamicType(d) = 'String';

SELECT count()
FROM test
WHERE d.String IS NOT NULL;

SELECT count()
FROM test
WHERE dynamicType(d) = 'Date';

SELECT count()
FROM test
WHERE d.Date IS NOT NULL;

SELECT count()
FROM test
WHERE dynamicType(d) = 'Array(Variant(String, UInt64))';

SELECT count()
FROM test
WHERE NOT empty(d.`Array(Variant(String, UInt64))`);

SELECT count()
FROM test
WHERE dynamicType(d) = 'Array(Array(Dynamic))';

SELECT count()
FROM test
WHERE NOT empty(d.`Array(Array(Dynamic))`);

SELECT count()
FROM test
WHERE d IS NULL;

SELECT count()
FROM test
WHERE NOT empty(d.`Tuple(a Array(Dynamic))`.a.String);

SELECT
    d,
    d.UInt64,
    d.String,
    d.`Array(Variant(String, UInt64))`
FROM test
FORMAT Null;

SELECT
    d.UInt64,
    d.String,
    d.`Array(Variant(String, UInt64))`
FROM test
FORMAT Null;

SELECT
    d.Int8,
    d.Date,
    d.`Array(String)`
FROM test
FORMAT Null;

SELECT
    d,
    d.UInt64,
    d.Date,
    d.`Array(Variant(String, UInt64))`,
    d.`Array(Variant(String, UInt64))`.size0,
    d.`Array(Variant(String, UInt64))`.UInt64
FROM test
FORMAT Null;

SELECT
    d.UInt64,
    d.Date,
    d.`Array(Variant(String, UInt64))`,
    d.`Array(Variant(String, UInt64))`.size0,
    d.`Array(Variant(String, UInt64))`.UInt64,
    d.`Array(Variant(String, UInt64))`.String
FROM test
FORMAT Null;

SELECT
    d,
    d.`Tuple(a UInt64, b String)`.a,
    d.`Array(Dynamic)`.`Variant(String, UInt64)`.UInt64,
    d.`Array(Variant(String, UInt64))`.UInt64
FROM test
FORMAT Null;

SELECT
    d.`Array(Dynamic)`.`Variant(String, UInt64)`.UInt64,
    d.`Array(Dynamic)`.size0,
    d.`Array(Variant(String, UInt64))`.UInt64
FROM test
FORMAT Null;

SELECT
    d.`Array(Array(Dynamic))`.size1,
    d.`Array(Array(Dynamic))`.UInt64,
    d.`Array(Array(Dynamic))`.`Map(String, Tuple(a UInt64))`.values.a
FROM test
FORMAT Null;

DROP TABLE test;