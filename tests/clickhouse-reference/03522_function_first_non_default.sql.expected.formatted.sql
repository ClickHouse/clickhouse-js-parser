SELECT firstNonDefault(NULL, 0, 43, 256) AS result;

SELECT firstNonDefault(NULL::Nullable(UInt8), CAST('0' AS Nullable(UInt8)), CAST('42' AS UInt8)) AS result;

SELECT firstNonDefault('', '0', 'hello') AS result;

SELECT firstNonDefault(NULL::Nullable(UInt8), CAST('0' AS UInt8)) AS result;

SELECT firstNonDefault(false, true) AS result;

SELECT firstNonDefault(CAST('[]' AS Array(UInt8)), CAST('[1, 2, 3]' AS Array(UInt8))) AS result;

SELECT
    firstNonDefault(NULL::Nullable(String), ''::String, 'foo') AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('0' AS UInt8), CAST('0' AS UInt16), CAST('42' AS UInt32)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('0' AS Int8), CAST('0' AS Int16), CAST('42' AS Int32)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('0' AS UInt32), CAST('0' AS UInt64), CAST('42' AS UInt128)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('0' AS Int128), CAST('0' AS Int128), CAST('42' AS Int128)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('0' AS UInt8), CAST('0' AS Int8), CAST('42' AS Int16)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('0' AS Int64), CAST('0' AS Int64), CAST('42' AS Int64)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('0.0' AS Float32), CAST('0.0' AS Float64), CAST('42.5' AS Float64)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('0' AS Float64), CAST('0.0' AS Float64), CAST('42.0' AS Float64)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(NULL::Nullable(Int32), CAST('0' AS Nullable(Int32)), CAST('42' AS Nullable(Int32))) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(NULL, CAST('0' AS Int32), CAST('42' AS Nullable(Int32))) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(''::String, '0'::String, 'hello'::String) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(''::FixedString(5), '0'::String, 'hello'::String) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('[]' AS Array(Int32)), CAST('[0]' AS Array(Int32)), CAST('[1, 2, 3]' AS Array(Int32))) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('[]' AS Array(String)), CAST('['''']' AS Array(String)), CAST('[''hello'']' AS Array(String))) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(NULL::Nullable(UInt8), CAST('0' AS UInt8), CAST('42' AS UInt8), CAST('100' AS UInt8)) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(NULL::Nullable(String), ''::String, '0'::String, 'hello'::String) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(NULL) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(0) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(''::String) AS result,
    toTypeName(result);

SELECT
    firstNonDefault(CAST('[]' AS Array(UInt8))) AS result,
    toTypeName(result);

SELECT firstNonDefault(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT firstNonDefault(0, 'hello'); -- { serverError NO_COMMON_TYPE }

SELECT firstNonDefault(CAST('[]' AS Array(UInt8)), 42); -- { serverError NO_COMMON_TYPE }

SELECT firstNonDefault(CAST('[]' AS Array(UInt8)), 'hello'); -- { serverError NO_COMMON_TYPE }

SELECT firstNonDefault(CAST('0' AS UInt64), CAST('1' AS Int64)); -- { serverError NO_COMMON_TYPE }

SELECT firstNonDefault(NULL::Nullable(Array(UInt8)), CAST('[]' AS Array(UInt8))); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT firstNonDefault(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, number)
FROM numbers(3);

DROP TABLE IF EXISTS test_first_truthy;

CREATE TABLE test_first_truthy
(
    a Nullable(Int32),
    b Nullable(Int32),
    c Nullable(String),
    d Array(Int32)
)
ENGINE = Memory();

INSERT INTO test_first_truthy;

SELECT
    a,
    b,
    firstNonDefault(a, b) AS result,
    toTypeName(firstNonDefault(a, b)) AS type
FROM test_first_truthy
ORDER BY `ALL` ASC;

SELECT
    c,
    firstNonDefault(c, 'default'::String) AS result,
    toTypeName(firstNonDefault(c, 'default'::String)) AS type
FROM test_first_truthy
ORDER BY `ALL` ASC;

SELECT
    d,
    firstNonDefault(d, CAST('[99, 100]' AS Array(Int32))) AS result,
    toTypeName(firstNonDefault(d, CAST('[99, 100]' AS Array(Int32)))) AS type
FROM test_first_truthy
ORDER BY length(result) ASC;

SELECT
    a,
    b,
    firstNonDefault(a + b, a * b, a - b) AS result,
    toTypeName(firstNonDefault(a + b, a * b, a - b)) AS type
FROM test_first_truthy
ORDER BY `ALL` ASC;

SELECT
    a,
    b,
    firstNonDefault(42, a, b) AS result1,
    firstNonDefault(0, a, b) AS result2,
    firstNonDefault(NULL, a, b) AS result3
FROM test_first_truthy
ORDER BY `ALL` ASC;

DROP TABLE test_first_truthy;