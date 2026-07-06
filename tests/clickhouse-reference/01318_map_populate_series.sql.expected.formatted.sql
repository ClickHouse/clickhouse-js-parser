DROP TABLE IF EXISTS map_test;

CREATE TABLE map_test
ENGINE = TinyLog() AS
SELECT
    number + 1 AS n,
    ([1, number], [1, 2]) AS map
FROM numbers(1, 5);

SELECT mapPopulateSeries((map).1, (map).2)
FROM map_test;

SELECT mapPopulateSeries((map).1, (map).2, toUInt64(3))
FROM map_test;

SELECT mapPopulateSeries((map).1, (map).2, toUInt64(10))
FROM map_test;

SELECT mapPopulateSeries((map).1, (map).2, 10)
FROM map_test;

SELECT mapPopulateSeries((map).1, (map).2, n)
FROM map_test;

SELECT mapPopulateSeries((map).1, [11, 22])
FROM map_test;

SELECT mapPopulateSeries([3, 4], (map).2)
FROM map_test;

SELECT mapPopulateSeries([toUInt64(3), 4], (map).2, n)
FROM map_test;

DROP TABLE map_test;

SELECT
    mapPopulateSeries([toUInt8(1), 2], [toUInt8(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toUInt16(1), 2], [toUInt16(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toUInt32(1), 2], [toUInt32(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toUInt64(1), 2], [toUInt64(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt8(1), 2], [toInt8(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt16(1), 2], [toInt16(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt32(1), 2], [toInt32(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt64(1), 2], [toInt64(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt8(-10), 2], [toInt8(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt16(-10), 2], [toInt16(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt32(-10), 2], [toInt32(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt64(-10), 2], [toInt64(1), 1]) AS res,
    toTypeName(res);

SELECT
    mapPopulateSeries([toInt64(-10), 2], [toInt64(1), 1], toInt64(-5)) AS res,
    toTypeName(res);

-- empty
SELECT mapPopulateSeries(CAST([] AS Array(UInt8)), CAST([] AS Array(UInt8)), 5);

SELECT
    mapPopulateSeries(['1', '2'], [1, 1]) AS res,
    toTypeName(res); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    mapPopulateSeries([1, 2, 3], [1, 1]) AS res,
    toTypeName(res); -- { serverError BAD_ARGUMENTS }

SELECT
    mapPopulateSeries([1, 2], [1, 1, 1]) AS res,
    toTypeName(res); -- { serverError BAD_ARGUMENTS }