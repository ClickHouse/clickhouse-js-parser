DROP TABLE IF EXISTS tab;

CREATE TABLE tab
ENGINE = Memory() AS
SELECT ([1, number], [toInt32(2), 2]) AS map
FROM numbers(1, 10);

-- mapAdd
SELECT mapAdd([1], [1]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapAdd(([1], [1])); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT mapAdd(([1], [1]), map)
FROM tab; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapAdd(([toUInt64(1)], [1]), map)
FROM tab; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapAdd(([toUInt64(1), 2], [toInt32(1)]), map)
FROM tab; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT mapAdd(([toUInt64(1)], [toInt32(1)]), map)
FROM tab;

SELECT mapAdd(CAST(map AS Tuple(Array(UInt8), Array(UInt8))), ([1], [1]), ([2], [2]))
FROM tab;

-- cleanup
DROP TABLE tab;

-- check types
SELECT
    mapAdd(([toUInt8(1), 2], [1, 1]), ([toUInt8(1), 2], [1, 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([toUInt16(1), 2], [toUInt16(1), 1]), ([toUInt16(1), 2], [toUInt16(1), 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([toUInt32(1), 2], [toUInt32(1), 1]), ([toUInt32(1), 2], [toUInt32(1), 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([toUInt64(1), 2], [toUInt64(1), 1]), ([toUInt64(1), 2], [toUInt64(1), 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([toInt8(1), 2], [toInt8(1), 1]), ([toInt8(1), 2], [toInt8(1), 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([toInt16(1), 2], [toInt16(1), 1]), ([toInt16(1), 2], [toInt16(1), 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([toInt32(1), 2], [toInt32(1), 1]), ([toInt32(1), 2], [toInt32(1), 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([toInt64(1), 2], [toInt64(1), 1]), ([toInt64(1), 2], [toInt64(1), 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([1, 2], [toFloat32(1.1), 1]), ([1, 2], [2.2, 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([1, 2], [toFloat64(1.1), 1]), ([1, 2], [2.2, 1])) AS res,
    toTypeName(res);

SELECT
    mapAdd(([toFloat32(1), 2], [toFloat64(1.1), 1]), ([toFloat32(1), 2], [2.2, 1])) AS res,
    toTypeName(res); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    mapAdd(([1, 2], [toFloat64(1.1), 1]), ([1, 2], [1, 1])) AS res,
    toTypeName(res); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapAdd((['a', 'b'], [1, 1]), ([key], [1]))
FROM values('key String', 'b', 'c', 'd');

SELECT
    mapAdd((CAST(['a', 'b'] AS Array(FixedString(1))), [1, 1]), ([key], [1])) AS res,
    toTypeName(res)
FROM values('key FixedString(1)', 'b', 'c', 'd');

SELECT mapAdd((CAST(['a', 'b'] AS Array(LowCardinality(String))), [1, 1]), ([key], [1]))
FROM values('key String', 'b', 'c', 'd');

SELECT
    mapAdd((key, val), (key, val)) AS res,
    toTypeName(res)
FROM values('key Array(Enum16(''a''=1, ''b''=2)), val Array(Int16)', (['a'], [1]), (['b'], [1]));

SELECT
    mapAdd((key, val), (key, val)) AS res,
    toTypeName(res)
FROM values('key Array(Enum8(''a''=1, ''b''=2)), val Array(Int16)', (['a'], [1]), (['b'], [1]));

SELECT
    mapAdd((key, val), (key, val)) AS res,
    toTypeName(res)
FROM values('key Array(UUID), val Array(Int32)', (['00000000-89ab-cdef-0123-456789abcdef'], [1]), (['11111111-89ab-cdef-0123-456789abcdef'], [2]));

-- mapSubtract, same rules as mapAdd
SELECT
    mapSubtract(([toUInt8(1), 2], [1, 1]), ([toUInt8(1), 2], [1, 1])) AS res,
    toTypeName(res);

SELECT
    mapSubtract(([toUInt8(1), 2], [1, 1]), ([toUInt8(1), 2], [2, 2])) AS res,
    toTypeName(res); -- overflow

SELECT
    mapSubtract(([toUInt8(1), 2], [toInt32(1), 1]), ([toUInt8(1), 2], [toInt16(2), 2])) AS res,
    toTypeName(res);

SELECT
    mapSubtract(([1, 2], [toFloat32(1.1), 1]), ([1, 2], [2.2, 1])) AS res,
    toTypeName(res);

SELECT
    mapSubtract(([toUInt8(3)], [toInt32(1)]), ([toUInt8(1), 2], [toInt32(2), 2])) AS res,
    toTypeName(res);