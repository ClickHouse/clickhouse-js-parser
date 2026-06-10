SELECT
    toIntervalSecond(1),
    toIntervalMinute(1),
    toIntervalHour(1);

SELECT
    toIntervalDay(1),
    toIntervalWeek(1),
    toIntervalMonth(1);

SELECT
    toIntervalQuarter(1),
    toIntervalYear(1);

SELECT toDate('2001-09-29');

SELECT
    toDate('2001-09-29') + toIntervalDay(7) AS x,
    toTypeName(x);

SELECT
    toDate('2001-10-01') - toIntervalDay(7) AS x,
    toTypeName(x);

SELECT
    toDate('2001-09-29') + 7 AS x,
    toTypeName(x);

SELECT
    toDate('2001-10-01') - 7 AS x,
    toTypeName(x);

SELECT
    toDate('2001-09-29') + toIntervalHour(1) AS x,
    toTypeName(x);

SELECT
    toDate('2001-09-29') - toIntervalHour(1) AS x,
    toTypeName(x);

SELECT
    toDate('2001-10-01') - toDate('2001-09-28') AS x,
    toTypeName(x);

SELECT toDateTime('2001-09-28 01:00:00') + toIntervalHour(23);

SELECT toDateTime('2001-09-28 23:00:00') - toIntervalHour(23);

SET session_timezone = 'Europe/Amsterdam';

SELECT
    toDate('2001-09-29') + toIntervalSecond(12345) AS x,
    toTypeName(x);

SELECT
    toDate('2001-09-29') + toIntervalMillisecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate('2001-09-29') + toIntervalMicrosecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate('2001-09-29') + toIntervalNanosecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate('2001-09-29') - toIntervalSecond(12345) AS x,
    toTypeName(x);

SELECT
    toDate('2001-09-29') - toIntervalMillisecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate('2001-09-29') - toIntervalMicrosecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate('2001-09-29') - toIntervalNanosecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate32('2001-09-29') + toIntervalSecond(12345) AS x,
    toTypeName(x);

SELECT
    toDate32('2001-09-29') + toIntervalMillisecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate32('2001-09-29') + toIntervalMicrosecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate32('2001-09-29') + toIntervalNanosecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate32('2001-09-29') - toIntervalSecond(12345) AS x,
    toTypeName(x);

SELECT
    toDate32('2001-09-29') - toIntervalMillisecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate32('2001-09-29') - toIntervalMicrosecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDate32('2001-09-29') - toIntervalNanosecond(12345) AS x,
    toTypeName(x); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    toDateTime('2001-12-29 03:00:00') - toDateTime('2001-12-27 12:00:00') AS x,
    toTypeName(x);

SELECT -toIntervalHour(23);

SELECT toIntervalDay(1) + toIntervalHour(1);

SELECT toIntervalDay(1) - toIntervalHour(1); -- select date '2001-09-28' + time '03:00';
-- select time '01:00' + interval '3 hours';
-- select time '05:00' - time '03:00';
-- select time '05:00' - interval '2 hours';
-- select 900 * interval '1 second'; -- interval '00:15:00'
-- select (21 * interval '1 day') x, toTypeName(x); -- interval '21 days'
-- select (double precision '3.5' * interval '1 hour') x, toTypeName(x); -- interval '03:30:00'
-- select (interval '1 hour' / double precision '1.5') x, toTypeName(x); -- interval '00:40:00'