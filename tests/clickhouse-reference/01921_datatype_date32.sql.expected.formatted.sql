DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    x1 Date32
)
ENGINE = Memory();

INSERT INTO t1;

SELECT x1
FROM t1;

SELECT '-------toYear---------';

SELECT toYear(x1)
FROM t1;

SELECT toMonth(x1)
FROM t1;

SELECT toQuarter(x1)
FROM t1;

SELECT toDayOfMonth(x1)
FROM t1;

SELECT toDayOfWeek(x1)
FROM t1;

SELECT toDayOfYear(x1)
FROM t1;

SELECT toHour(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toMinute(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toSecond(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toStartOfDay(x1, 'Asia/Istanbul')
FROM t1;

SELECT toMonday(x1)
FROM t1;

SELECT toISOWeek(x1)
FROM t1;

SELECT toISOYear(x1)
FROM t1;

SELECT toWeek(x1)
FROM t1;

SELECT toYearWeek(x1)
FROM t1;

SELECT toStartOfWeek(x1)
FROM t1;

SELECT toLastDayOfWeek(x1)
FROM t1;

SELECT toStartOfMonth(x1)
FROM t1;

SELECT toStartOfQuarter(x1)
FROM t1;

SELECT toStartOfYear(x1)
FROM t1;

SELECT toStartOfSecond(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toStartOfMinute(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toStartOfFiveMinutes(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toStartOfTenMinutes(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toStartOfFifteenMinutes(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toStartOfHour(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toStartOfISOYear(x1)
FROM t1;

SELECT toRelativeYearNum(x1, 'Asia/Istanbul')
FROM t1;

SELECT toRelativeQuarterNum(x1, 'Asia/Istanbul')
FROM t1;

SELECT toRelativeMonthNum(x1, 'Asia/Istanbul')
FROM t1;

SELECT toRelativeWeekNum(x1, 'Asia/Istanbul')
FROM t1;

SELECT toRelativeDayNum(x1, 'Asia/Istanbul')
FROM t1;

SELECT toRelativeHourNum(x1, 'Asia/Istanbul')
FROM t1;

SELECT toRelativeMinuteNum(x1, 'Asia/Istanbul')
FROM t1;

SELECT toRelativeSecondNum(x1, 'Asia/Istanbul')
FROM t1;

SELECT toTimeWithFixedDate(x1)
FROM t1; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toYYYYMM(x1)
FROM t1;

SELECT toYYYYMMDD(x1)
FROM t1;

SELECT toYYYYMMDDhhmmss(x1)
FROM t1;

SELECT addSeconds(x1, 3600)
FROM t1;

SELECT addMinutes(x1, 60)
FROM t1;

SELECT addHours(x1, 1)
FROM t1;

SELECT addDays(x1, 7)
FROM t1;

SELECT addWeeks(x1, 1)
FROM t1;

SELECT addMonths(x1, 1)
FROM t1;

SELECT addQuarters(x1, 1)
FROM t1;

SELECT addYears(x1, 1)
FROM t1;

SELECT subtractSeconds(x1, 3600)
FROM t1;

SELECT subtractMinutes(x1, 60)
FROM t1;

SELECT subtractHours(x1, 1)
FROM t1;

SELECT subtractDays(x1, 7)
FROM t1;

SELECT subtractWeeks(x1, 1)
FROM t1;

SELECT subtractMonths(x1, 1)
FROM t1;

SELECT subtractQuarters(x1, 1)
FROM t1;

SELECT subtractYears(x1, 1)
FROM t1;

SELECT
    toDate32('1900-01-01'),
    toDate32(toDate('2000-01-01'));

SELECT
    toDate32OrZero('1899-01-01'),
    toDate32OrNull('1899-01-01');

SELECT
    toDate32OrZero(''),
    toDate32OrNull('');

SELECT (
        SELECT toDate32OrZero('')
    );

SELECT (
        SELECT toDate32OrNull('')
    );

SELECT toString(T.d) AS dateStr
FROM (
        SELECT '1900-01-01'::Date32 AS d
        UNION ALL
        SELECT '1969-12-31'::Date32
        UNION ALL
        SELECT '1970-01-01'::Date32
        UNION ALL
        SELECT '2149-06-06'::Date32
        UNION ALL
        SELECT '2149-06-07'::Date32
        UNION ALL
        SELECT '2299-12-31'::Date32
    ) AS T
ORDER BY T.d ASC;