DROP TABLE IF EXISTS rate_test;

CREATE TABLE rate_test
(
    timestamp UInt32,
    event UInt32
)
ENGINE = Memory();

INSERT INTO rate_test;

SELECT 1. = boundingRatio(timestamp, event)
FROM rate_test;

DROP TABLE IF EXISTS rate_test2;

CREATE TABLE rate_test2
(
    uid UInt32 DEFAULT 1,
    timestamp DateTime,
    event UInt32
)
ENGINE = Memory();

INSERT INTO rate_test2 (timestamp, event);

SELECT 1. = boundingRatio(timestamp, event)
FROM rate_test2;

DROP TABLE rate_test;

DROP TABLE rate_test2;

SELECT boundingRatio(number, number * 1.5)
FROM numbers(10);

SELECT boundingRatio(1000 + number, number * 1.5)
FROM numbers(10);

SELECT boundingRatio(1000 + number, number * 1.5 - 111)
FROM numbers(10);

SELECT
    number % 10 AS k,
    boundingRatio(1000 + number, number * 1.5 - 111)
FROM numbers(100)
GROUP BY k
WITH TOTALS
ORDER BY k ASC;

SELECT boundingRatio(1000 + number, number * 1.5 - 111)
FROM numbers(2);

SELECT boundingRatio(1000 + number, number * 1.5 - 111)
FROM numbers(1);

SELECT boundingRatio(1000 + number, number * 1.5 - 111)
FROM numbers(1)
WHERE 0;

SELECT boundingRatio(number, exp(number)) = exp(1) - 1
FROM numbers(2);