SELECT
    number,
    toDateTime('1981-04-01 22:40:00', 'Europe/Moscow') + toIntervalSecond(number * 600) AS k,
    timezoneOffset(k) AS t,
    toUnixTimestamp(k) AS s
FROM numbers(4);

SELECT
    number,
    toDateTime('1981-09-30 23:00:00', 'Europe/Moscow') + toIntervalSecond(number * 600) AS k,
    timezoneOffset(k) AS t,
    toUnixTimestamp(k) AS s
FROM numbers(18);

SELECT
    number,
    toDateTime('2020-03-21 22:40:00', 'Asia/Tehran') + toIntervalSecond(number * 600) AS k,
    timezoneOffset(k) AS t,
    toUnixTimestamp(k) AS s
FROM numbers(4);

SELECT
    number,
    toDateTime('2020-09-20 23:00:00', 'Asia/Tehran') + toIntervalSecond(number * 600) AS k,
    timezoneOffset(k) AS t,
    toUnixTimestamp(k) AS s
FROM numbers(18);

SELECT timezoneOffset(toDateTime('2018-08-21 22:20:00', 'Australia/Lord_Howe'));

SELECT timezoneOffset(toDateTime('2018-02-21 22:20:00', 'Australia/Lord_Howe'));

SELECT
    number,
    toDateTime('2020-10-04 01:40:00', 'Australia/Lord_Howe') + toIntervalSecond(number * 600) AS k,
    timezoneOffset(k) AS t,
    toUnixTimestamp(k) AS s
FROM numbers(4);

SELECT
    number,
    toDateTime('2019-04-07 01:00:00', 'Australia/Lord_Howe') + toIntervalSecond(number * 600) AS k,
    timezoneOffset(k) AS t,
    toUnixTimestamp(k) AS s
FROM numbers(18);

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('1981-04-01 00:00:00', 'Europe/Moscow') + toIntervalSecond(number * 600) AS x,
    timezoneOffset(x) AS res,
    toDateTime(toString(x), 'UTC') - x AS calc
FROM numbers(576)
WHERE res != calc;

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('1981-09-30 00:00:00', 'Europe/Moscow') + toIntervalSecond(number * 600) AS x,
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
FROM numbers(18)
WHERE res != calc;

SELECT
    toUnixTimestamp(x) AS tt,
    toDateTime('2019-04-07 01:00:00', 'Australia/Lord_Howe') + toIntervalSecond(number * 600) AS x,
    timezoneOffset(x) AS res,
    toDateTime(toString(x), 'UTC') - x AS calc
FROM numbers(18)
WHERE res != calc;

SELECT
    number,
    toDateTime('1970-06-01 00:00:00', 'Europe/Moscow') + toIntervalYear(number) AS DST_Y,
    timezoneOffset(DST_Y) AS t
FROM numbers(51)
WHERE t != 10800;

SELECT
    min(toDateTime('2011-01-01 00:00:00', 'Europe/Moscow') + toIntervalDay(number) AS day) AS start,
    max(day) AS `end`,
    count(1),
    concat(toString(toYear(day)), '_', toString(timezoneOffset(day))) AS DST
FROM numbers(365 * 4 + 1)
GROUP BY DST
ORDER BY start ASC;

SELECT
    number,
    toDateTime('1970-06-01 00:00:00', 'Asia/Tehran') + toIntervalYear(number) AS DST_Y,
    timezoneOffset(DST_Y) AS t
FROM numbers(51)
WHERE t != 12600;

SELECT
    number,
    toDateTime('1970-08-01 00:00:00', 'Asia/Shanghai') + toIntervalYear(number) AS DST_Y,
    timezoneOffset(DST_Y) AS t
FROM numbers(51)
WHERE t != 28800;