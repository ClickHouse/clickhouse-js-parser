SET enable_extended_results_for_datetime_functions = '1';

-- We want toStartOfInterval to give exactly the same results as toStartOfX, where X is any type of interval
-- Nanoseconds
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 8, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalNanosecond(1)) AS a,
    toStartOfNanosecond(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 8, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalNanosecond(1)) AS a,
    toStartOfNanosecond(dt) AS b;

WITH toDateTime64(-79999999.9761238, 8, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalNanosecond(1)) AS a,
    toStartOfNanosecond(dt) AS b;

-- Microseconds
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 6, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMicrosecond(1)) AS a,
    toStartOfMicrosecond(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 6, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMicrosecond(1)) AS a,
    toStartOfMicrosecond(dt) AS b;

WITH toDateTime64(-79999999.9761238, 6, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMicrosecond(1)) AS a,
    toStartOfMicrosecond(dt) AS b;

-- Milliseconds
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMillisecond(1)) AS a,
    toStartOfMillisecond(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMillisecond(1)) AS a,
    toStartOfMillisecond(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMillisecond(1)) AS a,
    toStartOfMillisecond(dt) AS b;

-- Seconds
-- DateTime64
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalSecond(1)) AS a,
    toStartOfSecond(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalSecond(1)) AS a,
    toStartOfSecond(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalSecond(1)) AS a,
    toStartOfSecond(dt) AS b;

-- DateTime32
WITH toDateTime(23119945, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalSecond(1)) AS a,
    toStartOfSecond(dt) AS b;

-- Minutes
-- DateTime64
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMinute(1)) AS a,
    toStartOfMinute(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMinute(1)) AS a,
    toStartOfMinute(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMinute(1)) AS a,
    toStartOfMinute(dt) AS b;

-- DateTime32
WITH toDateTime(23119945, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMinute(1)) AS a,
    toStartOfMinute(dt) AS b;

-- Hours
-- DateTime64
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalHour(1)) AS a,
    toStartOfHour(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalHour(1)) AS a,
    toStartOfHour(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalHour(1)) AS a,
    toStartOfHour(dt) AS b;

-- DateTime32
WITH toDateTime(23119945, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalHour(1)) AS a,
    toStartOfHour(dt) AS b;

-- Days
-- DateTime64
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalDay(1)) AS a,
    toStartOfDay(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalDay(1)) AS a,
    toStartOfDay(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalDay(1)) AS a,
    toStartOfDay(dt) AS b;

-- Date32
-- Extended In Bounds
WITH toDate32(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalDay(1)) AS a,
    toStartOfDay(dt) AS b;

-- DateTime
WITH toDateTime(23119945, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalDay(1)) AS a,
    toStartOfDay(dt) AS b;

-- Date
WITH toDate(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalDay(1)) AS a,
    toStartOfDay(dt) AS b;

-- Weeks
-- Day32, DayTime64
-- Day, DayTime
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalWeek(1)) AS a,
    toStartOfWeek(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalWeek(1)) AS a,
    toStartOfWeek(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalWeek(1)) AS a,
    toStartOfWeek(dt) AS b;

-- Date32
-- Extended In Bounds
WITH toDate32(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalWeek(1)) AS a,
    toStartOfWeek(dt) AS b;

-- DateTime
WITH toDateTime(23119945, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalWeek(1)) AS a,
    toStartOfWeek(dt) AS b;

-- Date
WITH toDate(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalWeek(1)) AS a,
    toStartOfWeek(dt) AS b;

-- Months
-- Day, DayTime
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMonth(1)) AS a,
    toStartOfMonth(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMonth(1)) AS a,
    toStartOfMonth(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMonth(1)) AS a,
    toStartOfMonth(dt) AS b;

-- Date32
-- Extended In Bounds
WITH toDate32(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMonth(1)) AS a,
    toStartOfMonth(dt) AS b;

-- DateTime
WITH toDateTime(23119945, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMonth(1)) AS a,
    toStartOfMonth(dt) AS b;

-- Date
WITH toDate(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalMonth(1)) AS a,
    toStartOfMonth(dt) AS b;

-- Quarters
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalQuarter(1)) AS a,
    toStartOfQuarter(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalQuarter(1)) AS a,
    toStartOfQuarter(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalQuarter(1)) AS a,
    toStartOfQuarter(dt) AS b;

-- Date32
-- Extended In Bounds
WITH toDate32(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalQuarter(1)) AS a,
    toStartOfQuarter(dt) AS b;

-- DateTime
WITH toDateTime(23119945, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalQuarter(1)) AS a,
    toStartOfQuarter(dt) AS b;

-- Date
WITH toDate(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalQuarter(1)) AS a,
    toStartOfQuarter(dt) AS b;

-- Years
-- Extended In Bounds
WITH toDateTime64(23119945.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalYear(1)) AS a,
    toStartOfYear(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(799999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalYear(1)) AS a,
    toStartOfYear(dt) AS b;

WITH toDateTime64(-79999999.9761238, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalYear(1)) AS a,
    toStartOfYear(dt) AS b;

-- Date32
-- Extended In Bounds
WITH toDate32(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalYear(1)) AS a,
    toStartOfYear(dt) AS b;

-- Extended Out of Bounds
WITH toDateTime64(7999999999.976124, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalYear(1)) AS a,
    toStartOfYear(dt) AS b;

-- DateTime
WITH toDateTime(23119945, 3, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalYear(1)) AS a,
    toStartOfYear(dt) AS b;

-- Date
WITH toDate(23119945, 'UTC') AS dt

SELECT
    toStartOfInterval(dt, toIntervalYear(1)) AS a,
    toStartOfYear(dt) AS b;