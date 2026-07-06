SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('2019-04-07 01:00:00', 'Australia/Lord_Howe') + toIntervalSecond(number * 600) AS x,
    toString(x) AS xx
FROM numbers(20);

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('1981-04-01 00:00:00', 'Asia/Istanbul') + toIntervalSecond(number * 600) AS x,
    timezoneOffset(x) AS res,
    toDateTime(toString(x), 'UTC') - x AS calc
FROM numbers(576)
WHERE res != calc;

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('1981-09-30 00:00:00', 'Asia/Istanbul') + toIntervalSecond(number * 600) AS x,
    timezoneOffset(x) AS res,
    toDateTime(toString(x), 'UTC') - x AS calc
FROM numbers(576)
WHERE res != calc;

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('2020-03-21 00:00:00', 'Asia/Tehran') + toIntervalSecond(number * 600) AS x,
    timezoneOffset(x) AS res,
    toDateTime(toString(x), 'UTC') - x AS calc
FROM numbers(576)
WHERE res != calc;

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('2020-09-20 00:00:00', 'Asia/Tehran') + toIntervalSecond(number * 600) AS x,
    timezoneOffset(x) AS res,
    toDateTime(toString(x), 'UTC') - x AS calc
FROM numbers(576)
WHERE res != calc;

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('2020-10-04 01:40:00', 'Australia/Lord_Howe') + toIntervalSecond(number * 600) AS x,
    timezoneOffset(x) AS res,
    toDateTime(toString(x), 'UTC') - x AS calc
FROM numbers(576)
WHERE res != calc;

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('2019-04-07 01:00:00', 'Australia/Lord_Howe') + toIntervalSecond(number * 600) AS x,
    timezoneOffset(x) AS res,
    toDateTime(toString(x), 'UTC') - x AS calc
FROM numbers(576)
WHERE res != calc;