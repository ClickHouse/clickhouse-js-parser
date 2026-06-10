SET session_timezone = 'Europe/Amsterdam';

DROP TABLE IF EXISTS with_fill_staleness;

CREATE TABLE with_fill_staleness
(
    a DateTime,
    b DateTime,
    c UInt64
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO with_fill_staleness SELECT
    toDateTime('2016-06-15 23:00:00') + number AS a,
    a AS b,
    number AS c
FROM numbers(30)
WHERE number % 5 = 0;

SELECT
    a,
    c,
    'original' AS original
FROM with_fill_staleness
ORDER BY a ASC WITH FILL INTERPOLATE (c AS c);

SELECT
    a,
    c,
    'original' AS original
FROM with_fill_staleness
ORDER BY a ASC WITH FILL STALENESS toIntervalSecond(1) INTERPOLATE (c AS c);

SELECT
    a,
    c,
    'original' AS original
FROM with_fill_staleness
ORDER BY a ASC WITH FILL STALENESS toIntervalSecond(3) INTERPOLATE (c AS c);

SELECT
    a,
    c,
    'original' AS original
FROM with_fill_staleness
ORDER BY a DESC WITH FILL STALENESS toIntervalSecond(-2) INTERPOLATE (c AS c);

SELECT
    a,
    c,
    'original' AS original
FROM with_fill_staleness
ORDER BY a ASC WITH FILL TO toDateTime('2016-06-15 23:00:40') STEP 3 STALENESS toIntervalSecond(7) INTERPOLATE (c AS c);

SELECT
    a,
    b,
    c,
    'original' AS original
FROM with_fill_staleness
ORDER BY
    a ASC WITH FILL STALENESS toIntervalSecond(2),
    b ASC WITH FILL FROM 0 TO 3 INTERPOLATE (c AS c);

SELECT
    a,
    b,
    c,
    'original' AS original
FROM with_fill_staleness
ORDER BY
    a ASC WITH FILL STALENESS toIntervalSecond(2),
    b ASC WITH FILL TO toDateTime('2016-06-15 23:01:00') STEP 2 STALENESS 5 INTERPOLATE (c AS c);