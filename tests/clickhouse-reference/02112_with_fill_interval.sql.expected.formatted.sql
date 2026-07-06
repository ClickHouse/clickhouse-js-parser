DROP TABLE IF EXISTS with_fill_date;

CREATE TABLE with_fill_date
(
    d Date,
    d32 Date32
)
ENGINE = Memory();

INSERT INTO with_fill_date;

INSERT INTO with_fill_date;

INSERT INTO with_fill_date;

INSERT INTO with_fill_date;

SELECT
    d,
    count()
FROM with_fill_date
GROUP BY d
ORDER BY d ASC WITH FILL STEP toIntervalDay(1)
LIMIT 5;

SELECT
    toStartOfWeek(d) AS d,
    count()
FROM with_fill_date
GROUP BY d
ORDER BY d ASC WITH FILL STEP toIntervalWeek(1)
LIMIT 5;

SELECT
    toStartOfMonth(d) AS d,
    count()
FROM with_fill_date
GROUP BY d
ORDER BY d ASC WITH FILL STEP toIntervalMonth(1)
LIMIT 5;

SELECT
    toStartOfMonth(d) AS d,
    count()
FROM with_fill_date
GROUP BY d
ORDER BY d ASC WITH FILL FROM toDate('2020-01-01') TO toDate('2021-01-01') STEP toIntervalMonth(3);

SELECT
    d,
    count()
FROM with_fill_date
GROUP BY d
ORDER BY d ASC WITH FILL STEP toIntervalHour(1)
LIMIT 5; -- { serverError INVALID_WITH_FILL_EXPRESSION }

SELECT
    d32,
    count()
FROM with_fill_date
GROUP BY d32
ORDER BY d32 ASC WITH FILL STEP toIntervalDay(1)
LIMIT 5;

SELECT
    toStartOfWeek(d32) AS d32,
    count()
FROM with_fill_date
GROUP BY d32
ORDER BY d32 ASC WITH FILL STEP toIntervalWeek(1)
LIMIT 5;

SELECT
    toStartOfMonth(d32) AS d32,
    count()
FROM with_fill_date
GROUP BY d32
ORDER BY d32 ASC WITH FILL STEP toIntervalMonth(1)
LIMIT 5;

SELECT
    toStartOfMonth(d32) AS d32,
    count()
FROM with_fill_date
GROUP BY d32
ORDER BY d32 ASC WITH FILL FROM toDate('2020-01-01') TO toDate('2021-01-01') STEP toIntervalMonth(3);

DROP TABLE with_fill_date;

CREATE TABLE with_fill_date
(
    d DateTime('UTC'),
    d64 DateTime64(3, 'UTC')
)
ENGINE = Memory();

INSERT INTO with_fill_date;

INSERT INTO with_fill_date;

SELECT
    d,
    count()
FROM with_fill_date
GROUP BY d
ORDER BY d ASC WITH FILL STEP toIntervalMinute(15)
LIMIT 5;

SELECT
    toStartOfHour(d) AS d,
    count()
FROM with_fill_date
GROUP BY d
ORDER BY d ASC WITH FILL STEP toIntervalHour(6)
LIMIT 5;

SELECT
    toStartOfDay(d) AS d,
    count()
FROM with_fill_date
GROUP BY d
ORDER BY d ASC WITH FILL STEP toIntervalDay(10)
LIMIT 5;

SELECT
    d64,
    count()
FROM with_fill_date
GROUP BY d64
ORDER BY d64 ASC WITH FILL STEP toIntervalMinute(15)
LIMIT 5;

SELECT
    toStartOfHour(d64) AS d64,
    count()
FROM with_fill_date
GROUP BY d64
ORDER BY d64 ASC WITH FILL STEP toIntervalHour(6)
LIMIT 5;

SELECT
    toStartOfDay(d64) AS d64,
    count()
FROM with_fill_date
GROUP BY d64
ORDER BY d64 ASC WITH FILL STEP toIntervalDay(10)
LIMIT 5;

SELECT number
FROM numbers(100)
ORDER BY number ASC WITH FILL STEP toIntervalHour(1); -- { serverError INVALID_WITH_FILL_EXPRESSION }

CREATE TABLE with_fill_date
(
    d Date,
    id UInt32
)
ENGINE = Memory();

INSERT INTO with_fill_date;

INSERT INTO with_fill_date;

INSERT INTO with_fill_date;

INSERT INTO with_fill_date;

SELECT
    toStartOfMonth(d) AS d,
    id,
    count()
FROM with_fill_date
GROUP BY
    d,
    id
ORDER BY
    d ASC WITH FILL FROM toDate('2020-01-01') TO toDate('2020-05-01') STEP toIntervalMonth(1),
    id ASC WITH FILL FROM 1 TO 5;

SELECT d
FROM (
        SELECT toDate(1) AS d
    )
ORDER BY d DESC WITH FILL FROM toDate(3) TO toDate(0) STEP toIntervalDay(-1);