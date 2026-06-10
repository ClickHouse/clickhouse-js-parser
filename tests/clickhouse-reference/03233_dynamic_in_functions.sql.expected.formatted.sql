-- Tags: no-fasttest
SET allow_experimental_dynamic_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt64,
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test SELECT
    number,
    number
FROM numbers(4);

SELECT
    d + 1 AS res,
    toTypeName(res)
FROM test;

SELECT
    1 + d AS res,
    toTypeName(res)
FROM test;

SELECT
    d + x AS res,
    toTypeName(res)
FROM test;

SELECT
    x + d AS res,
    toTypeName(res)
FROM test;

SELECT
    d + d AS res,
    toTypeName(res)
FROM test;

SELECT
    d + 1 + d AS res,
    toTypeName(res)
FROM test;

SELECT
    d + x + d AS res,
    toTypeName(res)
FROM test;

SELECT
    d + NULL AS res,
    toTypeName(res)
FROM test;

SELECT
    d < 2 AS res,
    toTypeName(res)
FROM test;

SELECT
    d < d AS res,
    toTypeName(res)
FROM test;

SELECT
    d < x AS res,
    toTypeName(res)
FROM test;

SELECT
    d > 2 AS res,
    toTypeName(res)
FROM test;

SELECT
    d > d AS res,
    toTypeName(res)
FROM test;

SELECT
    d > x AS res,
    toTypeName(res)
FROM test;

SELECT
    d = 2 AS res,
    toTypeName(res)
FROM test;

SELECT
    d = d AS res,
    toTypeName(res)
FROM test;

SELECT
    d = x AS res,
    toTypeName(res)
FROM test;

SELECT
    d = NULL AS res,
    toTypeName(res)
FROM test;

SELECT *
FROM test
WHERE d < 2;

SELECT *
FROM test
WHERE d > 2;

SELECT *
FROM test
WHERE d = 2;

SELECT *
FROM test
WHERE d < d;

SELECT *
FROM test
WHERE d > d;

SELECT *
FROM test
WHERE d = d;

SELECT *
FROM test
WHERE d < x;

SELECT *
FROM test
WHERE d > x;

SELECT *
FROM test
WHERE d = x;

SELECT *
FROM test
WHERE d = NULL;

SELECT
    exp2(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    sin(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    cos(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    tan(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    mortonEncode(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    hilbertEncode(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    bitmaskToList(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    bitPositionsToArray(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    isFinite(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    sipHash64(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    sipHash128(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    intHash32(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    intHash64(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    h3CellAreaM2(585763170430222335 + d * 549755813888) AS res,
    toTypeName(res)
FROM test;

SELECT
    h3CellAreaRads2(585763170430222335 + d * 549755813888) AS res,
    toTypeName(res)
FROM test;

SELECT
    h3Distance(585763170430222335 + d * 549755813888, 585763170430222335 + (d + 1) * 549755813888) AS res,
    toTypeName(res)
FROM test;

SELECT
    sqid(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    sipHash64(d, x) AS res,
    toTypeName(res)
FROM test;

SELECT
    'str_' || d AS res,
    toTypeName(res)
FROM test;

SELECT
    'str_' || d || x AS res,
    toTypeName(res)
FROM test;

SELECT
    'str_' || d || d AS res,
    toTypeName(res)
FROM test;

SELECT
    'str_' || d || x || d AS res,
    toTypeName(res)
FROM test;

SELECT
    d || NULL AS res,
    toTypeName(res)
FROM test;

SELECT
    'str_' || d || NULL AS res,
    toTypeName(res)
FROM test;

DROP TABLE test;

CREATE TABLE test
(
    x Nullable(UInt64),
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test SELECT
    number % 2 ? NULL : number,
    number
FROM numbers(4);

CREATE TABLE test
(
    x String,
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test SELECT
    'str_' || number,
    'str_' || number
FROM numbers(4);

SELECT
    d < 'str_2' AS res,
    toTypeName(res)
FROM test;

SELECT
    d > 'str_2' AS res,
    toTypeName(res)
FROM test;

SELECT
    d = 'str_2' AS res,
    toTypeName(res)
FROM test;

SELECT *
FROM test
WHERE d < 'str_2';

SELECT *
FROM test
WHERE d > 'str_2';

SELECT *
FROM test
WHERE d = 'str_2';

SELECT
    upper(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    appendTrailingCharIfAbsent(d, 'd') AS res,
    toTypeName(res)
FROM test;

SELECT
    match(d, 'str') AS res,
    toTypeName(res)
FROM test;

SELECT
    concatWithSeparator('|', d, d) AS res,
    toTypeName(res)
FROM test;

SELECT
    extract(d, '([0-3])') AS res,
    toTypeName(res)
FROM test;

SELECT
    startsWith(d, 'str') AS res,
    toTypeName(res)
FROM test;

SELECT
    length(d) AS res,
    toTypeName(res)
FROM test;

SELECT
    replaceAll(d, 'str', 'a') AS res,
    toTypeName(res)
FROM test;

SELECT
    repeat(d, 2) AS res,
    toTypeName(res)
FROM test;

SELECT
    substring(d, 1, 3) AS res,
    toTypeName(res)
FROM test;

TRUNCATE TABLE test;

INSERT INTO test SELECT
    'str_' || number,
    toFixedString('str_' || number, 5)
FROM numbers(4);

CREATE TABLE test
(
    x Nullable(String),
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test SELECT
    number % 2 ? NULL : 'str_' || number,
    'str_' || number
FROM numbers(4);

INSERT INTO test SELECT
    number % 2 ? NULL : 'str_' || number,
    toFixedString('str_' || number, 5)
FROM numbers(4);

INSERT INTO test SELECT
    number,
    number % 2 ? NULL : number
FROM numbers(4);

SELECT
    sipHash64(d, d) AS res,
    toTypeName(res)
FROM test;

INSERT INTO test SELECT
    number % 2 ? NULL : number,
    number % 2 ? NULL : number
FROM numbers(4);

INSERT INTO test SELECT
    number % 2 ? NULL : number,
    NULL
FROM numbers(4);

INSERT INTO test SELECT
    'str_' || number,
    number % 2 ? NULL : 'str_' || number
FROM numbers(4);

INSERT INTO test SELECT
    'str_' || number,
    number % 2 ? NULL : toFixedString('str_' || number, 5)
FROM numbers(4);

INSERT INTO test SELECT
    number % 2 ? NULL : 'str_' || number,
    number % 2 ? NULL : toFixedString('str_' || number, 5)
FROM numbers(4);

CREATE TABLE test
(
    x UInt64,
    d Dynamic(max_types = 5)
)
ENGINE = Memory();

INSERT INTO test;

SELECT
    d + 1 AS res,
    toTypeName(res),
    dynamicType(res)
FROM test;

SELECT
    1 + d AS res,
    toTypeName(res),
    dynamicType(res)
FROM test;

SELECT
    d + x AS res,
    toTypeName(res),
    dynamicType(res)
FROM test;

SELECT
    x + d AS res,
    toTypeName(res),
    dynamicType(res)
FROM test;

SELECT
    d + d AS res,
    toTypeName(res),
    dynamicType(res)
FROM test;

SELECT
    d + 1 + d AS res,
    toTypeName(res),
    dynamicType(res)
FROM test;

SELECT
    d + x + d AS res,
    toTypeName(res),
    dynamicType(res)
FROM test;

SELECT
    d + NULL AS res,
    toTypeName(res),
    dynamicType(res)
FROM test;

SELECT
    d < 5 AS res,
    toTypeName(res)
FROM test;

SELECT
    d > 5 AS res,
    toTypeName(res)
FROM test;

SELECT
    d = 5 AS res,
    toTypeName(res)
FROM test;

SELECT *
FROM test
WHERE d < 5;

SELECT *
FROM test
WHERE d > 5;

SELECT *
FROM test
WHERE d = 5;

INSERT INTO test;

CREATE TABLE test
(
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test;

INSERT INTO test SELECT range(number + 1)
FROM numbers(4);

SELECT
    d[1] AS res,
    toTypeName(res)
FROM test;

INSERT INTO test;

SELECT d + 1
FROM test; -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT length(d)
FROM test; -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT d[1]
FROM test; -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT sipHash64(d)
FROM test;

SELECT sipHash64(d, 42)
FROM test;

SELECT sipHash64(d, d)
FROM test;