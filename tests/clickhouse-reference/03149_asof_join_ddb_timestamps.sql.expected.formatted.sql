DROP TABLE IF EXISTS events0;

DROP TABLE IF EXISTS probe0;

SET session_timezone = 'UTC';

SET enable_analyzer = '1';

SET join_algorithm = 'full_sorting_merge';

SET join_use_nulls = '1';

CREATE TABLE events0
ENGINE = MergeTree()
ORDER BY COALESCE(begin, toDateTime('9999-12-31 23:59:59')) AS
SELECT
    toNullable(toDateTime('2023-03-21 13:00:00') + toIntervalHour(number)) AS begin,
    number AS value
FROM numbers(4);

INSERT INTO events0;

CREATE TABLE probe0
ENGINE = MergeTree()
ORDER BY COALESCE(begin, toDateTime('9999-12-31 23:59:59')) AS
SELECT toNullable(toDateTime('2023-03-21 12:00:00') + toIntervalHour(number)) AS begin
FROM numbers(10);

INSERT INTO probe0;

SELECT
    p.begin,
    e.value
FROM
    probe0 AS p
ASOF INNER JOIN events0 AS e
    ON p.begin >= e.begin
ORDER BY p.begin ASC;

SELECT
    p.begin,
    e.value
FROM
    probe0 AS p
ASOF INNER JOIN events0 AS e
    USING (begin)
ORDER BY p.begin ASC
SETTINGS join_use_nulls = '0';

SELECT
    p.begin,
    e.value
FROM
    probe0 AS p
ASOF LEFT JOIN events0 AS e
    ON p.begin >= e.begin
ORDER BY p.begin ASC;

SELECT
    p.begin,
    e.value
FROM
    probe0 AS p
ASOF LEFT JOIN events0 AS e
    USING (begin)
ORDER BY p.begin ASC
SETTINGS join_use_nulls = '0';

SELECT
    p.begin,
    e.value
FROM
    probe0 AS p
ASOF RIGHT JOIN events0 AS e
    ON p.begin >= e.begin
ORDER BY e.begin ASC; -- { serverError NOT_IMPLEMENTED}

SELECT
    p.begin,
    e.value
FROM
    probe0 AS p
ASOF RIGHT JOIN events0 AS e
    USING (begin)
ORDER BY e.begin ASC; -- { serverError NOT_IMPLEMENTED}

SELECT
    p.begin,
    e.value
FROM
    probe0 AS p
ASOF LEFT JOIN (
        SELECT *
        FROM events0
        WHERE log(value + 5) > 10
    ) AS e
    ON p.begin + toIntervalHour(2) >= e.begin + toIntervalHour(1)
ORDER BY p.begin ASC;