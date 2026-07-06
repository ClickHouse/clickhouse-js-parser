-- Before UNIX epoch
WITH toDateTime64('1959-09-16 19:20:12.999999998', 9, 'UTC') AS dt1,

toDateTime64('1959-09-16 19:20:12.999999999', 9, 'UTC') AS dt2

SELECT
    dt1 < dt2,
    dt1 + toIntervalNanosecond(1) = dt2,
    dt1 + toIntervalNanosecond(2) > dt2,
    dt1 + toIntervalNanosecond(3) > dt2;

-- At UNIX epoch border
WITH toDateTime64('1969-12-31 23:59:59.999999998', 9, 'UTC') AS dt1,

toDateTime64('1969-12-31 23:59:59.999999999', 9, 'UTC') AS dt2

SELECT
    dt1 < dt2,
    dt1 + toIntervalNanosecond(1) = dt2,
    dt1 + toIntervalNanosecond(2) > dt2,
    dt1 + toIntervalNanosecond(3) > dt2;

-- After UNIX epoch
WITH toDateTime64('2001-12-31 23:59:59.999999998', 9, 'UTC') AS dt1,

toDateTime64('2001-12-31 23:59:59.999999999', 9, 'UTC') AS dt2

SELECT
    dt1 < dt2,
    dt1 + toIntervalNanosecond(1) = dt2,
    dt1 + toIntervalNanosecond(2) > dt2,
    dt1 + toIntervalNanosecond(3) > dt2;

-- At upper DT64 bound (DT64 precision is lower here by design)
WITH toDateTime64('2282-12-31 23:59:59.999998', 6, 'UTC') AS dt1,

toDateTime64('2282-12-31 23:59:59.999999', 6, 'UTC') AS dt2

SELECT
    dt1 < dt2,
    dt1 + toIntervalMicrosecond(1) = dt2,
    dt1 + toIntervalMicrosecond(2) > dt2,
    dt1 + toIntervalMicrosecond(3) > dt2;