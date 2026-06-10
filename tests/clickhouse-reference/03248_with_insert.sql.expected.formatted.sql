DROP TABLE IF EXISTS x;

CREATE TABLE x
ENGINE = Log() AS
SELECT *
FROM numbers(0);

SYSTEM STOP MERGES x;

INSERT INTO x WITH y AS (
    SELECT *
    FROM numbers(10)
)

SELECT *
FROM y
INTERSECT
WITH y AS (
    SELECT *
    FROM numbers(10)
)

SELECT *
FROM numbers(5);

INSERT INTO x WITH y AS (
    SELECT *
    FROM numbers(10)
)

SELECT *
FROM numbers(5)
INTERSECT
WITH y AS (
    SELECT *
    FROM numbers(10)
)

SELECT *
FROM y;

SELECT *
FROM x;

DROP TABLE x;

CREATE TABLE x
(
    d date
)
ENGINE = Log();

INSERT INTO x WITH y AS (
    SELECT
        number,
        plus(toDate('2025-01-01'), toIntervalYear(number)) AS new_date
    FROM numbers(10)
)

SELECT y.new_date
FROM y;