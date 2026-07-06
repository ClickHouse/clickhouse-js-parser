SET session_timezone = 'Etc/UTC';

SELECT toDateTime('2017-10-30 08:18:19') + toIntervalDay(1) + toIntervalMonth(1) - toIntervalYear(1);

SELECT toDateTime('2017-10-30 08:18:19') + toIntervalHour(1) + toIntervalMinute(1000) + toIntervalSecond(10);

SELECT toDateTime('2017-10-30 08:18:19') + toIntervalDay(1) + toIntervalMonth(number)
FROM `system`.numbers
LIMIT 20;

SELECT
    toDateTime('2016-02-29 01:02:03') + toIntervalYear(number),
    toDateTime('2016-02-29 01:02:03') + toIntervalMonth(number)
FROM `system`.numbers
LIMIT 16;

SELECT toDateTime('2016-02-29 01:02:03') - toIntervalQuarter(1);

SELECT
    toDateTime('2000-01-01 12:00:00') + toIntervalSecond(1234567) AS x,
    toTypeName(x);

SELECT
    toDateTime('2000-01-01 12:00:00') + toIntervalMillisecond(1234567) AS x,
    toTypeName(x);

SELECT
    toDateTime('2000-01-01 12:00:00') + toIntervalMicrosecond(1234567) AS x,
    toTypeName(x);

SELECT
    toDateTime('2000-01-01 12:00:00') + toIntervalNanosecond(1234567) AS x,
    toTypeName(x);

SELECT
    toDateTime('2000-01-01 12:00:00') - toIntervalSecond(1234567) AS x,
    toTypeName(x);

SELECT
    toDateTime('2000-01-01 12:00:00') - toIntervalMillisecond(1234567) AS x,
    toTypeName(x);

SELECT
    toDateTime('2000-01-01 12:00:00') - toIntervalMicrosecond(1234567) AS x,
    toTypeName(x);

SELECT
    toDateTime('2000-01-01 12:00:00') - toIntervalNanosecond(1234567) AS x,
    toTypeName(x);

SELECT
    toDateTime64('2000-01-01 12:00:00.678', 3) - toIntervalMillisecond(12345) AS x,
    toTypeName(x);

SELECT
    toDateTime64('2000-01-01 12:00:00.67898', 5) - toIntervalMillisecond(12345) AS x,
    toTypeName(x);

SELECT
    toDateTime64('2000-01-01 12:00:00.67', 2) - toIntervalMillisecond(12345) AS x,
    toTypeName(x);

SELECT toDateTime64('3000-01-01 12:00:00.12345', 0) + toIntervalNanosecond(0); -- { serverError DECIMAL_OVERFLOW }

SELECT toDateTime64('3000-01-01 12:00:00.12345', 0) + toIntervalMicrosecond(0);

-- Check that the error is thrown during typechecking, not execution.
SELECT materialize(toDate('2000-01-01')) + toIntervalNanosecond(1)
FROM numbers(0); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }