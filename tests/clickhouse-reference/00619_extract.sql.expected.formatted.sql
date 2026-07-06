SELECT toDayOfMonth(toDate('2017-06-15'));

SELECT toMonth(toDate('2017-06-15'));

SELECT toYear(toDate('2017-06-15'));

SELECT toSecond(toDateTime('2017-12-31 18:59:58'));

SELECT toMinute(toDateTime('2017-12-31 18:59:58'));

SELECT toHour(toDateTime('2017-12-31 18:59:58'));

SELECT toDayOfMonth(toDateTime('2017-12-31 18:59:58'));

SELECT toMonth(toDateTime('2017-12-31 18:59:58'));

SELECT toYear(toDateTime('2017-12-31 18:59:58'));

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
    OrderId UInt64,
    OrderName String,
    OrderDate DateTime
)
ENGINE = Log();

INSERT INTO Orders;

SELECT
    toYear(OrderDate) AS OrderYear,
    toMonth(OrderDate) AS OrderMonth,
    toDayOfMonth(OrderDate) AS OrderDay,
    toHour(OrderDate),
    toMinute(OrderDate),
    toSecond(OrderDate)
FROM Orders
WHERE OrderId = 1;

DROP TABLE Orders; -- TODO:
-- SELECT EXTRACT(WEEK FROM toDate('2017-06-15'));
-- SELECT EXTRACT(WEEK FROM toDateTime('2017-12-31 18:59:58'));
-- SELECT EXTRACT(MINUTE_SECOND FROM toDateTime('2017-12-31 18:59:58'));
-- SELECT EXTRACT(HOUR_SECOND FROM toDateTime('2017-12-31 18:59:58'));
-- SELECT EXTRACT(HOUR_MINUTE FROM toDateTime('2017-12-31 18:59:58'));
-- SELECT EXTRACT(DAY_SECOND FROM toDateTime('2017-12-31 18:59:58'));
-- SELECT EXTRACT(DAY_MINUTE FROM toDateTime('2017-12-31 18:59:58'));
-- SELECT EXTRACT(DAY_HOUR FROM toDateTime('2017-12-31 18:59:58'));
-- SELECT EXTRACT(YEAR_MONTH FROM toDateTime('2017-12-31 18:59:58'));
-- SELECT EXTRACT(QUARTER FROM toDate('2017-06-15'));
-- SELECT EXTRACT(DAY_SECOND FROM toDate('2017-06-15'));
-- SELECT EXTRACT(DAY_MINUTE FROM toDate('2017-06-15'));
-- SELECT EXTRACT(DAY_HOUR FROM toDate('2017-06-15'));
-- SELECT EXTRACT(YEAR_MONTH FROM toDate('2017-06-15'));
-- SELECT EXTRACT(QUARTER FROM toDateTime('2017-12-31 18:59:58'));
-- Maybe:
-- SELECT EXTRACT (YEAR FROM DATE '2014-08-22') AS RESULT;