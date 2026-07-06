-- { echo }
DROP TABLE IF EXISTS map_test;

CREATE TABLE map_test
ENGINE = TinyLog() AS
SELECT
    number + 1 AS n,
    map(1, 1, number, 2) AS m
FROM numbers(1, 5);

SELECT mapPopulateSeries(m)
FROM map_test;

SELECT mapPopulateSeries(m, toUInt64(3))
FROM map_test;

SELECT mapPopulateSeries(m, toUInt64(10))
FROM map_test;

SELECT mapPopulateSeries(m, 10)
FROM map_test;

SELECT mapPopulateSeries(m, n)
FROM map_test;

DROP TABLE map_test;

SELECT
    mapPopulateSeries(map(toUInt8(1), toUInt8(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toUInt16(1), toUInt16(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toUInt32(1), toUInt32(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toUInt64(1), toUInt64(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toUInt128(1), toUInt128(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toUInt256(1), toUInt256(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt8(1), toInt8(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt16(1), toInt16(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt32(1), toInt32(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt64(1), toInt64(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt128(1), toInt128(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt256(1), toInt256(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt8(-10), toInt8(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt16(-10), toInt16(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt32(-10), toInt32(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt64(-10), toInt64(1), 2, 1)) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries(map(toInt64(-10), toInt64(1), 2, 1), toInt64(-5)) AS res,
    toTypeName(res);

SELECT mapPopulateSeries(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT mapPopulateSeries('asdf'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    mapPopulateSeries(map('1', 1, '2', 1)) AS res,
    toTypeName(res); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }