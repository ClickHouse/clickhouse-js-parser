DROP TABLE IF EXISTS nnd;

CREATE TABLE nnd
(
    id Int8,
    ts DateTime64(3, 'UTC'),
    metric Float64
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO nnd;

INSERT INTO nnd;

OPTIMIZE TABLE nnd;

-- shall work for precise intervals
-- INTERVAL 1 SECOND shall be default
SELECT (
        SELECT
            ts,
            metric,
            nonNegativeDerivative(metric, ts) OVER (PARTITION BY metric ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
        FROM nnd
        LIMIT 1
        OFFSET 5
    ) = (
        SELECT
            ts,
            metric,
            nonNegativeDerivative(metric, ts, toIntervalSecond(1)) OVER (PARTITION BY metric ORDER BY ts ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
        FROM nnd
        LIMIT 1
        OFFSET 5
    );

SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS deriv
FROM nnd;

-- Nanosecond
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalNanosecond(3)) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS deriv
FROM nnd;

-- Microsecond
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalMicrosecond(4)) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS deriv
FROM nnd;

-- Millisecond
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalMillisecond(5)) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS deriv
FROM nnd;

-- Second
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalSecond(6)) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd;

-- Minute
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalMinute(7)) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING) AS deriv
FROM nnd;

-- Hour
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalHour(8)) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd;

-- Day
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalDay(9)) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AS deriv
FROM nnd;

-- Week
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalWeek(10)) OVER (PARTITION BY id > 3 ORDER BY ts ASC, metric ASC ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd;

-- shall not work for month, quarter, year (intervals with floating number of seconds)
-- Month
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalMonth(11)) OVER (PARTITION BY metric ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- Quarter
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalQuarter(12)) OVER (PARTITION BY metric ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- Year
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalYear(13)) OVER (PARTITION BY metric ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- test against wrong arguments/types
SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, 1, toIntervalNanosecond(3)) OVER (PARTITION BY metric ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd; -- { serverError BAD_ARGUMENTS }

SELECT
    ts,
    metric,
    nonNegativeDerivative('string not datetime', ts, toIntervalNanosecond(3)) OVER (PARTITION BY metric ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd; -- { serverError BAD_ARGUMENTS }

SELECT
    ts,
    metric,
    nonNegativeDerivative(metric, ts, toIntervalNanosecond(3), id) OVER (PARTITION BY metric ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd; -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT
    ts,
    metric,
    nonNegativeDerivative(metric) OVER (PARTITION BY metric ORDER BY ts ASC, metric ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS deriv
FROM nnd; -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }