DROP TABLE IF EXISTS `3538_array_except1`;

DROP TABLE IF EXISTS `3538_array_except2`;

DROP TABLE IF EXISTS `3538_array_except3`;

DROP TABLE IF EXISTS `3538_array_except4`;

DROP TABLE IF EXISTS `3538_array_except5`;

DROP TABLE IF EXISTS `3538_array_except6`;

SELECT arrayExcept([1, 2, 3, 4], [3, 5]) AS result;

SELECT arrayExcept([1, 2, 2, 3], [2]) AS result;

SELECT arrayExcept(['apple', 'banana', 'cherry'], ['banana', 'date']) AS result;

SELECT arrayExcept(CAST('[]' AS Array(UInt8)), [1, 2]) AS result;

SELECT arrayExcept([1, 2, 3], CAST('[]' AS Array(UInt8))) AS result;

SELECT arrayExcept([1, 2, 3], [1, 2, 3]) AS result;

SELECT arrayExcept(['laptop', 'phone', 'tablet', 'watch'], ['watch', 'headphones']) AS result;

SELECT arrayExcept([200, 404, 404, 500, 503], [404, 500]) AS result;

SELECT arrayExcept([1, NULL, 2], [2]) AS result;

SELECT arrayExcept([1, 2, 3], [2, NULL]) AS result;

SELECT arrayExcept(materialize(['11', '2', '3', '4', '0']), materialize([1.5])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayExcept(materialize('11'), materialize('1')); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayExcept(materialize(['11', '2', '3', '4', '0']), materialize('1')); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayExcept(materialize([['11', '2', '3', '4', '0']]), materialize([['1']])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayExcept([1, 2, 3, 4], [3, 5]) AS result
FROM numbers(3);

SELECT arrayExcept(materialize([1, 2, 3, 4]), [3, 5]) AS result
FROM numbers(3);

WITH excludes AS (
    SELECT
        1 AS id,
        ['b', 'd'] AS exclude
    UNION ALL
    SELECT
        2 AS id,
        ['a', 'c']
    UNION ALL
    SELECT
        3 AS id,
        ['x', 'y']
)

SELECT
    id,
    arrayExcept(['a', 'b', 'c'], exclude) AS result
FROM excludes
ORDER BY id ASC;

SELECT arrayExcept(multiIf(number = 0, [1, 2, 3], number = 1, [4, 5, 6], [7, 8, 9]), [2, 5, 8]) AS result
FROM numbers(3);

SELECT arrayExcept(CAST('[''premium'', ''active'', ''new'']' AS Array(LowCardinality(String))), CAST('[''active'']' AS Array(LowCardinality(String)))) AS result;

SELECT arrayExcept(materialize(CAST('[''premium'', ''active'', ''new'']' AS Array(LowCardinality(String)))), CAST('[''active'']' AS Array(LowCardinality(String)))) AS result;

SELECT arrayExcept(CAST('[''premium'', ''active'', ''new'']' AS Array(LowCardinality(String))), materialize(CAST('[''active'']' AS Array(LowCardinality(String))))) AS result;

SELECT arrayExcept(materialize(CAST('[''premium'', ''active'', ''new'']' AS Array(LowCardinality(String)))), materialize(CAST('[''active'']' AS Array(LowCardinality(String))))) AS result;

SELECT arrayExcept(CAST('[''a'',''b'',''c'']' AS Array(LowCardinality(String))), CAST('[''b'',''d'']' AS Array(String))) AS result;

CREATE TABLE `3538_array_except1`
(
    id UInt32,
    source Array(UInt32),
    `except` Array(UInt32),
    except_null Array(Nullable(UInt32)),
    expected Array(UInt32)
)
ENGINE = Memory();

INSERT INTO `3538_array_except1`;

SELECT
    id,
    source,
    `except`,
    arrayExcept(source, `except`) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except1`
ORDER BY id ASC;

SELECT
    id,
    source,
    except_null,
    arrayExcept(source, except_null) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except1`
ORDER BY id ASC;

CREATE TABLE `3538_array_except2`
(
    id UInt32,
    source_null Array(Nullable(UInt32)),
    `except` Array(UInt32),
    expected Array(Nullable(UInt32)),
    except_null Array(Nullable(UInt32)),
    expected_null Array(Nullable(UInt32))
)
ENGINE = Memory();

INSERT INTO `3538_array_except2`;

SELECT
    id,
    source_null,
    `except`,
    arrayExcept(source_null, `except`) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except2`
ORDER BY id ASC;

SELECT
    id,
    source_null,
    except_null,
    arrayExcept(source_null, except_null) AS result,
    expected_null,
    if(result = expected_null, 'OK', 'NOK') AS status
FROM `3538_array_except2`
ORDER BY id ASC;

CREATE TABLE `3538_array_except3`
(
    id UInt32,
    source Array(String),
    `except` Array(String),
    except_null Array(Nullable(String)),
    expected Array(String)
)
ENGINE = Memory();

INSERT INTO `3538_array_except3`;

SELECT
    id,
    source,
    `except`,
    arrayExcept(source, `except`) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except3`
ORDER BY id ASC;

SELECT
    id,
    source,
    except_null,
    arrayExcept(source, except_null) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except3`
ORDER BY id ASC;

CREATE TABLE `3538_array_except4`
(
    id UInt32,
    source_null Array(Nullable(String)),
    `except` Array(String),
    expected Array(Nullable(String)),
    except_null Array(Nullable(String)),
    expected_null Array(Nullable(String))
)
ENGINE = Memory();

INSERT INTO `3538_array_except4`;

SELECT
    id,
    source_null,
    `except`,
    arrayExcept(source_null, `except`) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except4`
ORDER BY id ASC;

SELECT
    id,
    source_null,
    except_null,
    arrayExcept(source_null, except_null) AS result,
    expected_null,
    if(result = expected_null, 'OK', 'NOK') AS status
FROM `3538_array_except4`
ORDER BY id ASC;

CREATE TABLE `3538_array_except5`
(
    id UInt32,
    source Array(FixedString(5)),
    `except` Array(FixedString(5)),
    except_null Array(Nullable(FixedString(5))),
    expected Array(FixedString(5))
)
ENGINE = Memory();

INSERT INTO `3538_array_except5`;

SELECT
    id,
    source,
    `except`,
    arrayExcept(source, `except`) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except5`
ORDER BY id ASC;

SELECT
    id,
    source,
    except_null,
    arrayExcept(source, except_null) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except5`
ORDER BY id ASC;

CREATE TABLE `3538_array_except6`
(
    id UInt32,
    source_null Array(Nullable(FixedString(5))),
    `except` Array(FixedString(5)),
    expected Array(Nullable(FixedString(5))),
    except_null Array(Nullable(FixedString(5))),
    expected_null Array(Nullable(FixedString(5)))
)
ENGINE = Memory();

INSERT INTO `3538_array_except6`;

SELECT
    id,
    source_null,
    `except`,
    arrayExcept(source_null, `except`) AS result,
    expected,
    if(result = expected, 'OK', 'NOK') AS status
FROM `3538_array_except6`
ORDER BY id ASC;

SELECT
    id,
    source_null,
    except_null,
    arrayExcept(source_null, except_null) AS result,
    expected_null,
    if(result = expected_null, 'OK', 'NOK') AS status
FROM `3538_array_except6`
ORDER BY id ASC;