SET session_timezone = 'UTC';

SET use_legacy_to_time = '0';

-- Operations <Time> + <number>
SELECT toTime(12) + 1;

SELECT toTime(12) + 25;

SELECT toTime(12) + 1.1;

SELECT toTime(12) + 25.2;

-- Operations <Time> - <number>
SELECT toTime(12) - 1;

SELECT toTime(12) - 25;

SELECT toTime(12) - 1.1;

SELECT toTime(12) - 25.2;

-- Operations <Time> + <INTERVAL>
SELECT toTime(12) + toIntervalNanosecond(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) + toIntervalMicrosecond(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) + toIntervalMillisecond(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) + toIntervalSecond(1);

SELECT toTime(12) + toIntervalMinute(1);

SELECT toTime(12) + toIntervalHour(1);

SELECT toTime(12) + toIntervalDay(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) + toIntervalWeek(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) + toIntervalMonth(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) + toIntervalQuarter(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) + toIntervalYear(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- Operations <Time> - <INTERVAL>
SELECT toTime(12) - toIntervalNanosecond(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) - toIntervalMicrosecond(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) - toIntervalMillisecond(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) - toIntervalSecond(1);

SELECT toTime(72) - toIntervalMinute(1);

SELECT toTime(3610) - toIntervalHour(1);

SELECT toTime(12) - toIntervalMinute(1);

SELECT toTime(12) - toIntervalHour(1);

SELECT toTime(12) - toIntervalDay(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) - toIntervalWeek(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) - toIntervalMonth(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) - toIntervalQuarter(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT toTime(12) - toIntervalYear(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- Operations <Time> % <number>
SELECT toTime(12) % 1;

SELECT toTime(12) % 7;

SELECT toTime(12) % 25;

SELECT toTime(12) % 7.1;

SELECT toTime(12) % 25.2;

-- Operations <Time> - <Time>
SELECT toTime(12) - toTime(11);

SELECT toTime(12) - toTime(2);

SELECT toTime(12) - toTime(20);

-- Operations <Time64> + <number>
SELECT toTime64(12, 2) + 1;

SELECT toTime64(12, 2) + 25;

SELECT toTime64(12, 2) + 1.1;

SELECT toTime64(12, 2) + 25.2;

-- Operations <Time64> - <number>
SELECT toTime64(12, 2) - 1;

SELECT toTime64(12, 2) - 25;

SELECT toTime64(12, 2) - 1.1;

SELECT toTime64(12, 2) - 25.2;

-- Operations <Time64> + <INTERVAL>
SELECT toTime64(12, 2) + toIntervalNanosecond(1);

SELECT toTime64(12, 2) + toIntervalMicrosecond(1);

SELECT toTime64(12, 2) + toIntervalMillisecond(1);

SELECT toTime64(12, 2) + toIntervalSecond(1);

SELECT toTime64(12, 2) + toIntervalMinute(1);

SELECT toTime64(12, 2) + toIntervalHour(1);

SELECT toTime64(12, 2) + toIntervalDay(1);

SELECT toTime64(12, 2) + toIntervalWeek(1);

SELECT toTime64(12, 2) + toIntervalMonth(1);

SELECT toTime64(12, 2) + toIntervalQuarter(1);

-- Operations <Time64> - <INTERVAL>
SELECT toTime64(12, 2) - toIntervalNanosecond(1);

SELECT toTime64(12, 2) - toIntervalMicrosecond(1);

SELECT toTime64(12, 2) - toIntervalMillisecond(1);

SELECT toTime64(12, 2) - toIntervalSecond(1);

SELECT toTime64(72, 2) - toIntervalMinute(1);

SELECT toTime64(3610, 2) - toIntervalHour(1);

SELECT toTime64(86412, 2) - toIntervalDay(1);

SELECT toTime64(604812, 2) - toIntervalWeek(1);

SELECT toTime64(12, 2) - toIntervalMonth(1) + toIntervalMonth(1);

SELECT toTime64(12, 2) - toIntervalQuarter(1) + toIntervalQuarter(1);

-- Operations <Time64> - <Time64>
SELECT toTime64(12, 2) - toTime64(12, 2);

SELECT toTime64(12, 2) - toTime64(10.13, 2);

SELECT toTime64(12, 2) - toTime64(20.13, 2);