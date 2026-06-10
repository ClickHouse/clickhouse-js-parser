SELECT '----- NULL value -----';

SELECT NULL;

SELECT 1 + NULL;

SELECT abs(NULL);

SELECT NULL + NULL;

DROP TABLE IF EXISTS test1_00395;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE test1_00395
(
    col1 UInt64,
    col2 Nullable(UInt64),
    col3 String,
    col4 Nullable(String),
    col5 Array(UInt64),
    col6 Array(Nullable(UInt64)),
    col7 Array(String),
    col8 Array(Nullable(String)),
    d Date
)
ENGINE = MergeTree(d, (col1, d), 8192);

INSERT INTO test1_00395;

SELECT *
FROM test1_00395
ORDER BY
    col1 ASC,
    col2 ASC,
    col3 ASC,
    col4 ASC,
    col5 ASC,
    col6 ASC,
    col7 ASC,
    col8 ASC;

CREATE TABLE test1_00395
(
    col1 UInt64,
    col2 Nullable(UInt64),
    col3 String,
    col4 Nullable(String),
    col5 Array(UInt64),
    col6 Array(Nullable(UInt64)),
    col7 Array(String),
    col8 Array(Nullable(String)),
    d Date
)
ENGINE = Memory();

CREATE TABLE test1_00395
(
    col1 UInt64,
    col2 Nullable(UInt64),
    col3 String,
    col4 Nullable(String),
    col5 Array(UInt64),
    col6 Array(Nullable(UInt64)),
    col7 Array(String),
    col8 Array(Nullable(String)),
    d Date
)
ENGINE = TinyLog();

CREATE TABLE test1_00395
(
    col1 UInt64,
    col2 Nullable(UInt64),
    col3 String,
    col4 Nullable(String),
    col5 Array(UInt64),
    col6 Array(Nullable(UInt64)),
    col7 Array(String),
    col8 Array(Nullable(String)),
    d Date
)
ENGINE = Log();

CREATE TABLE test1_00395
(
    col1 UInt64,
    col2 Nullable(UInt64),
    col3 String,
    col4 Nullable(String),
    col5 Array(UInt64),
    col6 Array(Nullable(UInt64)),
    col7 Array(String),
    col8 Array(Nullable(String)),
    d Date
)
ENGINE = StripeLog();

CREATE TABLE test1_00395
(
    col1 Array(Nullable(UInt64))
)
ENGINE = Memory();

INSERT INTO test1_00395 (col1);

SELECT col1
FROM test1_00395
ORDER BY col1 ASC;

CREATE TABLE test1_00395
(
    col1 Nullable(UInt64),
    col2 UInt64
)
ENGINE = Memory();

DROP TABLE IF EXISTS test2;

CREATE TABLE test2
(
    col1 UInt64,
    col2 Nullable(UInt64)
)
ENGINE = Memory();

INSERT INTO test1_00395 (col1, col2);

INSERT INTO test2 (col1, col2) SELECT
    col1,
    col2
FROM test1_00395;

SELECT
    col1,
    col2
FROM test2
ORDER BY
    col1 ASC,
    col2 ASC;

CREATE TABLE test1_00395
(
    col1 Nullable(UInt64),
    col2 Nullable(UInt64)
)
ENGINE = Memory();

INSERT INTO test1_00395 (col1, col2);

SELECT
    col1,
    col2,
    col1 + col2,
    col1 * 7
FROM test1_00395
ORDER BY
    col1 ASC,
    col2 ASC;

SELECT sum(col1)
FROM test1_00395;

SELECT sum(col1 * 7)
FROM test1_00395;

SELECT
    col1,
    col2,
    isNull(col1),
    isNotNull(col2)
FROM test1_00395
ORDER BY
    col1 ASC,
    col2 ASC;

SELECT
    col1,
    col2,
    ifNull(col1, col2)
FROM test1_00395
ORDER BY
    col1 ASC,
    col2 ASC;

SELECT
    col1,
    col2,
    nullIf(col1, col2)
FROM test1_00395
ORDER BY
    col1 ASC,
    col2 ASC;

SELECT nullIf(1, NULL);

SELECT coalesce(NULL);

SELECT coalesce(NULL, 1);

SELECT coalesce(NULL, NULL, 1);

SELECT coalesce(NULL, 42, NULL, 1);

SELECT coalesce(NULL, NULL, NULL);

SELECT
    col1,
    col2,
    coalesce(col1, col2)
FROM test1_00395
ORDER BY
    col1 ASC,
    col2 ASC;

SELECT
    col1,
    col2,
    coalesce(col1, col2, 99)
FROM test1_00395
ORDER BY
    col1 ASC,
    col2 ASC;

SELECT res
FROM (
        SELECT
            col1,
            assumeNotNull(col1) AS res
        FROM test1_00395
    )
WHERE col1 IS NOT NULL
ORDER BY res ASC;

SELECT col1
FROM test1_00395
WHERE col1 IS NOT NULL
ORDER BY col1 ASC;

SELECT col1
FROM test1_00395
WHERE col1 IS NULL;

CREATE TABLE test1_00395
(
    col1 Nullable(String)
)
ENGINE = TinyLog();

INSERT INTO test1_00395;

SELECT
    col1,
    if(col1 IN ('a', 'b'), 1, 0) AS t,
    toTypeName(t)
FROM test1_00395;

SELECT
    col1,
    if(col1 IN ('a', 'b'), NULL, 0) AS t,
    toTypeName(t)
FROM test1_00395;

SELECT
    col1,
    multiIf(col1 IN ('a', 'b'), 1, 0) AS t,
    toTypeName(t)
FROM test1_00395;

SELECT
    col1,
    multiIf(col1 IN ('a', 'b'), NULL, 0) AS t,
    toTypeName(t)
FROM test1_00395;

SELECT
    col1,
    multiIf(col1 IN ('a', 'b'), 1, NULL) AS t,
    toTypeName(t)
FROM test1_00395;

SELECT multiIf(1, NULL, 1, 3, 4);

SELECT multiIf(1, 2, 1, NULL, 4);

SELECT multiIf(NULL, NULL, NULL);

SELECT multiIf(1, 'A', 1, NULL, 'DEF');

SELECT multiIf(1, toFixedString('A', 16), 1, NULL, toFixedString('DEF', 16));

SELECT multiIf(NULL, 2, 1, 3, 4);

SELECT multiIf(1, 2, NULL, 3, 4);

CREATE TABLE test1_00395
(
    col1 Nullable(Int8),
    col2 Nullable(UInt16),
    col3 Nullable(Float32)
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2, col3);

SELECT multiIf(col1 = 1, col2, col2 = 2, col3, col3 = 3, col1, 42)
FROM test1_00395;

CREATE TABLE test1_00395
(
    cond1 Nullable(UInt8),
    then1 Int8,
    cond2 UInt8,
    then2 Nullable(UInt16),
    then3 Nullable(Float32)
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (cond1, then1, cond2, then2, then3);

SELECT multiIf(cond1, then1, cond2, then2, then3)
FROM test1_00395;

SELECT [NULL];

SELECT [NULL, NULL, NULL];

SELECT [NULL, 2, 3];

SELECT [1, NULL, 3];

SELECT [1, 2, NULL];

SELECT [NULL, 'b', 'c'];

SELECT ['a', NULL, 'c'];

SELECT ['a', 'b', NULL];

SELECT arrayElement([1, NULL, 2, 3], 1);

SELECT arrayElement([1, NULL, 2, 3], 2);

SELECT arrayElement([1, NULL, 2, 3], 3);

SELECT arrayElement([1, NULL, 2, 3], 4);

SELECT arrayElement(['a', NULL, 'c', 'd'], 1);

SELECT arrayElement(['a', NULL, 'c', 'd'], 2);

SELECT arrayElement(['a', NULL, 'c', 'd'], 3);

SELECT arrayElement(['a', NULL, 'c', 'd'], 4);

CREATE TABLE test1_00395
(
    col1 UInt64
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1);

SELECT arrayElement([1, NULL, 2, 3], col1)
FROM test1_00395;

CREATE TABLE test1_00395
(
    col1 Array(Nullable(UInt64))
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1);

SELECT arrayElement(col1, 1)
FROM test1_00395;

SELECT arrayElement(col1, 2)
FROM test1_00395;

SELECT arrayElement(col1, 3)
FROM test1_00395;

SELECT arrayElement(col1, 4)
FROM test1_00395;

CREATE TABLE test1_00395
(
    col1 Array(Nullable(String))
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1);

CREATE TABLE test1_00395
(
    col1 Array(Nullable(UInt64)),
    col2 UInt64
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2);

SELECT arrayElement(col1, col2)
FROM test1_00395;

CREATE TABLE test1_00395
(
    col1 Array(Nullable(String)),
    col2 UInt64
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2);

SELECT has([1, NULL, 2, 3], 1);

SELECT has([1, NULL, 2, 3], NULL);

SELECT has([1, NULL, 2, 3], 2);

SELECT has([1, NULL, 2, 3], 3);

SELECT has([1, NULL, 2, 3], 4);

SELECT has(['a', NULL, 'def', 'ghij'], 'a');

SELECT has(['a', NULL, 'def', 'ghij'], NULL);

SELECT has(['a', NULL, 'def', 'ghij'], 'def');

SELECT has(['a', NULL, 'def', 'ghij'], 'ghij');

SELECT has([1, NULL, 2, 3], col1)
FROM test1_00395;

CREATE TABLE test1_00395
(
    col1 Nullable(UInt64)
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1);

CREATE TABLE test1_00395
(
    col1 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1);

SELECT has(['a', NULL, 'def', 'ghij'], col1)
FROM test1_00395;

CREATE TABLE test1_00395
(
    col1 Nullable(String)
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1);

SELECT has(col1, 2)
FROM test1_00395;

SELECT has(col1, 3)
FROM test1_00395;

SELECT has(col1, 4)
FROM test1_00395;

SELECT has(col1, 5)
FROM test1_00395;

SELECT has(col1, 7)
FROM test1_00395;

SELECT has(col1, NULL)
FROM test1_00395;

SELECT has(col1, 'a')
FROM test1_00395;

SELECT has(col1, 'bc')
FROM test1_00395;

SELECT has(col1, 'def')
FROM test1_00395;

SELECT has(col1, 'ghij')
FROM test1_00395;

INSERT INTO test1_00395 (col1, col2);

SELECT has(col1, col2)
FROM test1_00395;

CREATE TABLE test1_00395
(
    col1 Array(Nullable(UInt64)),
    col2 Nullable(UInt64)
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2);

CREATE TABLE test1_00395
(
    col1 Array(Nullable(String)),
    col2 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2);

CREATE TABLE test1_00395
(
    col1 Array(Nullable(String)),
    col2 Nullable(String)
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2);

CREATE TABLE test1_00395
(
    col1 Nullable(String),
    col2 Nullable(UInt8),
    col3 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2, col3);

SELECT
    col1,
    col2,
    count()
FROM test1_00395
GROUP BY
    col1,
    col2
ORDER BY
    col1 ASC,
    col2 ASC;

CREATE TABLE test1_00395
(
    col1 String,
    col2 Nullable(UInt8),
    col3 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2, col3);

CREATE TABLE test1_00395
(
    col1 Nullable(String),
    col2 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2);

SELECT
    col1,
    count()
FROM test1_00395
GROUP BY col1
ORDER BY col1 ASC;

CREATE TABLE test1_00395
(
    col1 Nullable(UInt8),
    col2 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2);

CREATE TABLE test1_00395
(
    col1 Nullable(UInt64),
    col2 UInt64,
    col3 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2, col3);

CREATE TABLE test1_00395
(
    col1 Nullable(UInt64),
    col2 UInt64,
    col3 Nullable(UInt64),
    col4 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2, col3, col4);

SELECT
    col1,
    col2,
    col3,
    count()
FROM test1_00395
GROUP BY
    col1,
    col2,
    col3
ORDER BY
    col1 ASC,
    col2 ASC,
    col3 ASC;

CREATE TABLE test1_00395
(
    col1 Array(Nullable(UInt8)),
    col2 String
)
ENGINE = TinyLog();

INSERT INTO test1_00395 (col1, col2);

DROP TABLE test2;