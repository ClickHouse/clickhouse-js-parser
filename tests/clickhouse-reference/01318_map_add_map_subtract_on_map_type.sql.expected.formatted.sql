DROP TABLE IF EXISTS tab;

CREATE TABLE tab
ENGINE = Memory() AS
SELECT map(1, toInt32(2), number, 2) AS m
FROM numbers(1, 10);

-- mapAdd
SELECT mapAdd(map(1, 1)); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT mapAdd(map(1, 1), m)
FROM tab; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapAdd(map(toUInt64(1), toInt32(1)), m)
FROM tab;

SELECT mapAdd(CAST(m AS Map(UInt8, UInt8)), map(1, 1), map(2, 2))
FROM tab;

-- cleanup
DROP TABLE tab;

-- check types
SELECT
    mapAdd(map(toUInt8(1), 1, 2, 1), map(toUInt8(1), 1, 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toUInt16(1), toUInt16(1), 2, 1), map(toUInt16(1), toUInt16(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toUInt32(1), toUInt32(1), 2, 1), map(toUInt32(1), toUInt32(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toUInt64(1), toUInt64(1), 2, 1), map(toUInt64(1), toUInt64(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toUInt128(1), toUInt128(1), 2, 1), map(toUInt128(1), toUInt128(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toUInt256(1), toUInt256(1), 2, 1), map(toUInt256(1), toUInt256(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toInt8(1), 1, 2, 1), map(toInt8(1), 1, 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toInt16(1), toInt16(1), 2, 1), map(toInt16(1), toInt16(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toInt32(1), toInt32(1), 2, 1), map(toInt32(1), toInt32(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toInt64(1), toInt64(1), 2, 1), map(toInt64(1), toInt64(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toInt128(1), toInt128(1), 2, 1), map(toInt128(1), toInt128(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(toInt256(1), toInt256(1), 2, 1), map(toInt256(1), toInt256(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(1, toFloat32(1.1), 2, 1), map(1, 2.2, 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(1., toFloat32(1.1), 2., 1), map(1., 2.2, 2., 1)) AS res,
    toTypeName(res); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    mapAdd(map(toLowCardinality('ab'), toFloat32(1.1), toLowCardinality('cd'), 1), map(toLowCardinality('ab'), 2.2, toLowCardinality('cd'), 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(1, toFloat64(1.1), 2, 1), map(1, 2.2, 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapAdd(map(1, toFloat64(1.1), 2, 1), map(1, 1, 2, 1)) AS res,
    toTypeName(res); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT mapAdd(map('a', 1, 'b', 1), map(key, 1))
FROM values('key String', 'b', 'c', 'd');

SELECT
    mapAdd(map(CAST('a' AS FixedString(1)), 1, 'b', 1), map(key, 1)) AS res,
    toTypeName(res)
FROM values('key String', 'b', 'c', 'd');

SELECT mapAdd(map(CAST('a' AS LowCardinality(String)), 1, 'b', 1), map(key, 1))
FROM values('key String', 'b', 'c', 'd');

SELECT
    mapAdd(map(key, val), map(key, val)) AS res,
    toTypeName(res)
FROM values('key Enum16(''a''=1, ''b''=2), val Int16', ('a', 1), ('b', 1));

SELECT
    mapAdd(map(key, val), map(key, val)) AS res,
    toTypeName(res)
FROM values('key Enum8(''a''=1, ''b''=2), val Int16', ('a', 1), ('b', 1));

SELECT
    mapAdd(map(key, val), map(key, val)) AS res,
    toTypeName(res)
FROM values('key UUID, val Int32', ('00000000-89ab-cdef-0123-456789abcdef', 1), ('11111111-89ab-cdef-0123-456789abcdef', 2));

-- mapSubtract, same rules as mapAdd
SELECT
    mapSubtract(map(toUInt8(1), 1, 2, 1), map(toUInt8(1), 1, 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapSubtract(map(toUInt8(1), 1, 2, 1), map(toUInt8(1), 2, 2, 2)) AS res,
    toTypeName(res); -- overflow

SELECT
    mapSubtract(map(toUInt8(1), toInt32(1), 2, 1), map(toUInt8(1), toInt16(2), 2, 2)) AS res,
    toTypeName(res);

SELECT
    mapSubtract(map(1, toFloat32(1.1), 2, 1), map(1, 2.2, 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapSubtract(map(toUInt8(3), toInt32(1)), map(toUInt8(1), toInt32(2), 2, 2)) AS res,
    toTypeName(res);