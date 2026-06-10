SELECT '-- Negative tests';

SELECT arrayDotProduct([1, 2]); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT arrayDotProduct([1, 2], 'abc'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayDotProduct('abc', [1, 2]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayDotProduct([1, 2], ['abc', 'def']); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT arrayDotProduct([1, 2], [3, 4, 5]); -- { serverError SIZES_OF_ARRAYS_DONT_MATCH }

SELECT dotProduct([1, 2], (3, 4, 5)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    CAST('[1, 2, 3]' AS Array(UInt8)) AS x,
    CAST('[4, 5, 6]' AS Array(UInt8)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[1, 2, 3]' AS Array(UInt16)) AS x,
    CAST('[4, 5, 6]' AS Array(UInt16)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[1, 2, 3]' AS Array(UInt32)) AS x,
    CAST('[4, 5, 6]' AS Array(UInt32)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[1, 2, 3]' AS Array(UInt64)) AS x,
    CAST('[4, 5, 6]' AS Array(UInt64)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[-1, -2, -3]' AS Array(Int8)) AS x,
    CAST('[4, 5, 6]' AS Array(Int8)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[-1, -2, -3]' AS Array(Int16)) AS x,
    CAST('[4, 5, 6]' AS Array(Int16)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[-1, -2, -3]' AS Array(Int32)) AS x,
    CAST('[4, 5, 6]' AS Array(Int32)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[-1, -2, -3]' AS Array(Int64)) AS x,
    CAST('[4, 5, 6]' AS Array(Int64)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[1, 2, 3]' AS Array(Float32)) AS x,
    CAST('[4, 5, 6]' AS Array(Float32)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[1, 2, 3]' AS Array(Float64)) AS x,
    CAST('[4, 5, 6]' AS Array(Float64)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

-- empty arrays
SELECT
    CAST('[]' AS Array(Float32)) AS x,
    CAST('[]' AS Array(Float32)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    CAST('[]' AS Array(UInt8)) AS x,
    CAST('[]' AS Array(UInt8)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('1' AS UInt8), CAST('2' AS UInt8), CAST('3' AS UInt8)) AS x,
    (CAST('4' AS UInt8), CAST('5' AS UInt8), CAST('6' AS UInt8)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('1' AS UInt16), CAST('2' AS UInt16), CAST('3' AS UInt16)) AS x,
    (CAST('4' AS UInt16), CAST('5' AS UInt16), CAST('6' AS UInt16)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('1' AS UInt32), CAST('2' AS UInt32), CAST('3' AS UInt32)) AS x,
    (CAST('4' AS UInt32), CAST('5' AS UInt32), CAST('6' AS UInt32)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('1' AS UInt64), CAST('2' AS UInt64), CAST('3' AS UInt64)) AS x,
    (CAST('4' AS UInt64), CAST('5' AS UInt64), CAST('6' AS UInt64)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('-1' AS Int8), CAST('-2' AS Int8), CAST('-3' AS Int8)) AS x,
    (CAST('4' AS Int8), CAST('5' AS Int8), CAST('6' AS Int8)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('-1' AS Int16), CAST('-2' AS Int16), CAST('-3' AS Int16)) AS x,
    (CAST('4' AS Int16), CAST('5' AS Int16), CAST('6' AS Int16)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('-1' AS Int32), CAST('-2' AS Int32), CAST('-3' AS Int32)) AS x,
    (CAST('4' AS Int32), CAST('5' AS Int32), CAST('6' AS Int32)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('-1' AS Int64), CAST('-2' AS Int64), CAST('-3' AS Int64)) AS x,
    (CAST('4' AS Int64), CAST('5' AS Int64), CAST('6' AS Int64)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('1' AS Float32), CAST('2' AS Float32), CAST('3' AS Float32)) AS x,
    (CAST('4' AS Float32), CAST('5' AS Float32), CAST('6' AS Float32)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('1' AS Float64), CAST('2' AS Float64), CAST('3' AS Float64)) AS x,
    (CAST('4' AS Float64), CAST('5' AS Float64), CAST('6' AS Float64)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    materialize([CAST('1' AS UInt8), CAST('2' AS UInt8), CAST('3' AS UInt8)]) AS x,
    [CAST('4' AS UInt8), CAST('5' AS UInt8), CAST('6' AS UInt8)] AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    materialize(CAST('[]' AS Array(Float32))) AS x,
    CAST('[]' AS Array(Float32)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    materialize(CAST('[]' AS Array(UInt8))) AS x,
    CAST('[]' AS Array(UInt8)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    [CAST('1' AS UInt16), CAST('2' AS UInt8), CAST('3' AS Float32)] AS x,
    [CAST('4' AS Int16), CAST('5' AS Float32), CAST('6' AS UInt8)] AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT
    (CAST('1' AS UInt16), CAST('2' AS UInt8), CAST('3' AS Float32)) AS x,
    (CAST('4' AS Int16), CAST('5' AS Float32), CAST('6' AS UInt8)) AS y,
    dotProduct(x, y) AS res,
    toTypeName(res);

SELECT scalarProduct([1, 2, 3], [4, 5, 6]);

SELECT scalarProduct((1, 2, 3), (4, 5, 6));

SELECT arrayDotProduct([1, 2, 3], [4, 5, 6]); -- actually no alias but the internal function for arrays

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt64,
    vec Array(Float32)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

SELECT
    id,
    arrayDotProduct(vec, vec)
FROM tab
ORDER BY id ASC;

SELECT
    id,
    arrayDotProduct(vec::Array(Float64), vec::Array(Float64))
FROM tab
ORDER BY id ASC;

SELECT
    id,
    arrayDotProduct(vec::Array(UInt32), vec::Array(UInt32))
FROM tab
ORDER BY id ASC;

SELECT
    id,
    arrayDotProduct(CAST('[5.0, 2.0, 2.0, 3.0, 5.0, 1.0, 2.0, 3.0, 5.0, 1.0, 2.0, 3.0, 5.0, 1.0, 2.0, 3.0, 5.0, 1.0, 2.0]' AS Array(Float32)), vec)
FROM tab
ORDER BY id ASC;

SELECT
    id,
    arrayDotProduct(CAST('[5.0, 2.0, 2.0, 3.0, 5.0, 1.0, 2.0, 3.0, 5.0, 1.0, 2.0, 3.0, 5.0, 1.0, 2.0, 3.0, 5.0, 1.0, 2.0]' AS Array(Float64)), vec)
FROM tab
ORDER BY id ASC;

SELECT
    id,
    arrayDotProduct(CAST('[5, 2, 2, 3, 5, 1, 2, 3, 5, 1, 2, 3, 5, 1, 2, 3, 5, 1, 2]' AS Array(UInt32)), vec)
FROM tab
ORDER BY id ASC;

DROP TABLE tab;