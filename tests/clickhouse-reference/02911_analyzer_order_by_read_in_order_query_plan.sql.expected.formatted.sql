SET optimize_read_in_order = '1', query_plan_read_in_order = '1', enable_analyzer = '1';

DROP TABLE IF EXISTS tab;

DROP TABLE IF EXISTS tab2;

DROP TABLE IF EXISTS tab3;

DROP TABLE IF EXISTS tab4;

DROP TABLE IF EXISTS tab5;

CREATE TABLE tab
(
    a UInt32,
    b UInt32,
    c UInt32,
    d UInt32
)
ENGINE = MergeTree()
ORDER BY ((a + b) * c, sin(a / b));

INSERT INTO tab SELECT
    number,
    number,
    number,
    number
FROM numbers(5);

-- { echoOn }
-- Exact match, single key
SELECT *
FROM tab
ORDER BY (a + b) * c ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY (a + b) * c ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

SELECT *
FROM tab
ORDER BY (a + b) * c DESC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY (a + b) * c DESC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- Exact match, full key
SELECT *
FROM tab
ORDER BY
    (a + b) * c ASC,
    sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c ASC,
                    sin(a / b) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

SELECT *
FROM tab
ORDER BY
    (a + b) * c DESC,
    sin(a / b) DESC NULLS FIRST;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c DESC,
                    sin(a / b) DESC NULLS FIRST
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- Exact match, mixed direction
SELECT *
FROM tab
ORDER BY
    (a + b) * c DESC,
    sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c DESC,
                    sin(a / b) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

SELECT *
FROM tab
ORDER BY
    (a + b) * c ASC,
    sin(a / b) DESC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c ASC,
                    sin(a / b) DESC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- Wrong order, full sort
SELECT *
FROM tab
ORDER BY
    sin(a / b) ASC,
    (a + b) * c ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    sin(a / b) ASC,
                    (a + b) * c ASC
            ))
    )
WHERE `explain` ILIKE '%sort description%';

-- Fixed point
SELECT *
FROM tab
WHERE (a + b) * c = 8
ORDER BY sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                WHERE (a + b) * c = 8
                ORDER BY sin(a / b) ASC
            ))
    )
WHERE `explain` ILIKE '%sort description%';

SELECT *
FROM tab
WHERE d + 1 = 2
ORDER BY
    (d + 1) * 4 ASC,
    (a + b) * c ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                WHERE d + 1 = 2
                ORDER BY
                    (d + 1) * 4 ASC,
                    (a + b) * c ASC
            ))
    )
WHERE `explain` ILIKE '%sort description%';

SELECT *
FROM tab
WHERE d + 1 = 3
    AND a + b = 4
    AND c = 2
ORDER BY
    (d + 1) * 4 ASC,
    sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                WHERE d + 1 = 3
                    AND a + b = 4
                    AND c = 2
                ORDER BY
                    (d + 1) * 4 ASC,
                    sin(a / b) ASC
            ))
    )
WHERE `explain` ILIKE '%sort description%';

-- Wrong order with fixed point
SELECT *
FROM tab
WHERE (a + b) * c = 8
ORDER BY sin(b / a) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                WHERE (a + b) * c = 8
                ORDER BY sin(b / a) ASC
            ))
    )
WHERE `explain` ILIKE '%sort description%';

-- Monotonicity
SELECT *
FROM tab
ORDER BY intDiv((a + b) * c, 2) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY intDiv((a + b) * c, 2) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

SELECT *
FROM tab
ORDER BY
    intDiv((a + b) * c, 2) ASC,
    sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    intDiv((a + b) * c, 2) ASC,
                    sin(a / b) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- select * from tab order by (a + b) * c, intDiv(sin(a / b), 2);
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c ASC,
                    intDiv(sin(a / b), 2) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- select * from tab order by (a + b) * c desc , intDiv(sin(a / b), 2);
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c DESC,
                    intDiv(sin(a / b), 2) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- select * from tab order by (a + b) * c, intDiv(sin(a / b), 2) desc;
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c ASC,
                    intDiv(sin(a / b), 2) DESC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- select * from tab order by (a + b) * c desc, intDiv(sin(a / b), 2) desc;
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c DESC,
                    intDiv(sin(a / b), 2) DESC NULLS FIRST
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- select * from tab order by (a + b) * c desc, intDiv(sin(a / b), -2);
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c DESC,
                    intDiv(sin(a / b), -2) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- select * from tab order by (a + b) * c desc, intDiv(intDiv(sin(a / b), -2), -3);
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c DESC,
                    intDiv(intDiv(sin(a / b), -2), -3) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- select * from tab order by (a + b) * c, intDiv(intDiv(sin(a / b), -2), -3);
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab
                ORDER BY
                    (a + b) * c ASC,
                    intDiv(intDiv(sin(a / b), -2), -3) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- Aliases
SELECT *
FROM (
        SELECT
            *,
            a + b AS x
        FROM tab
    )
ORDER BY x * c ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT
                            *,
                            a + b AS x
                        FROM tab
                    )
                ORDER BY x * c ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

SELECT *
FROM (
        SELECT
            *,
            a + b AS x,
            a / b AS y
        FROM tab
    )
ORDER BY
    x * c ASC,
    sin(y) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT
                            *,
                            a + b AS x,
                            a / b AS y
                        FROM tab
                    )
                ORDER BY
                    x * c ASC,
                    sin(y) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

SELECT *
FROM (
        SELECT
            *,
            a / b AS y
        FROM (
                SELECT
                    *,
                    a + b AS x
                FROM tab
            )
    )
ORDER BY
    x * c ASC,
    sin(y) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT
                            *,
                            a / b AS y
                        FROM (
                                SELECT
                                    *,
                                    a + b AS x
                                FROM tab
                            )
                    )
                ORDER BY
                    x * c ASC,
                    sin(y) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- { echoOff }
CREATE TABLE tab2
(
    x DateTime,
    y UInt32,
    z UInt32
)
ENGINE = MergeTree()
ORDER BY (x, y);

INSERT INTO tab2 SELECT
    toDate('2020-02-02') + number,
    number,
    number
FROM numbers(4);

-- { echoOn }
SELECT *
FROM tab2
ORDER BY
    toTimeZone(toTimezone(x, 'UTC'), 'CET') ASC,
    intDiv(intDiv(y, -2), -3) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab2
                ORDER BY
                    toTimeZone(toTimezone(x, 'UTC'), 'CET') ASC,
                    intDiv(intDiv(y, -2), -3) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

SELECT *
FROM tab2
ORDER BY
    toStartOfDay(x) ASC,
    intDiv(intDiv(y, -2), -3) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab2
                ORDER BY
                    toStartOfDay(x) ASC,
                    intDiv(intDiv(y, -2), -3) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- select * from tab2 where toTimezone(x, 'CET') = '2020-02-03 01:00:00' order by intDiv(intDiv(y, -2), -3);
SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM tab2
                WHERE toTimezone(x, 'CET') = '2020-02-03 01:00:00'
                ORDER BY intDiv(intDiv(y, -2), -3) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%';

-- { echoOff }
CREATE TABLE tab3
(
    a UInt32,
    b UInt32,
    c UInt32,
    d UInt32
)
ENGINE = MergeTree()
ORDER BY ((a + b) * c, sin(a / b));

INSERT INTO tab3 SELECT
    number,
    number,
    number,
    number
FROM numbers(5);

CREATE TABLE tab4
(
    a UInt32,
    b UInt32,
    c UInt32,
    d UInt32
)
ENGINE = MergeTree()
ORDER BY sin(a / b);

INSERT INTO tab4 SELECT
    number,
    number,
    number,
    number
FROM numbers(5);

CREATE TABLE tab5
(
    a UInt32,
    b UInt32,
    c UInt32,
    d UInt32
)
ENGINE = MergeTree()
ORDER BY (a + b) * c;

INSERT INTO tab5 SELECT
    number,
    number,
    number,
    number
FROM numbers(5);

-- { echoOn }
-- Union (not fully supported)
SELECT *
FROM (
        SELECT *
        FROM tab
        UNION ALL
        SELECT *
        FROM tab3
    )
ORDER BY
    (a + b) * c ASC,
    sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM tab
                        UNION ALL
                        SELECT *
                        FROM tab3
                    )
                ORDER BY
                    (a + b) * c ASC,
                    sin(a / b) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%'
    OR `explain` LIKE '%ReadType%';

SELECT *
FROM (
        SELECT *
        FROM tab
        WHERE (a + b) * c = 8
        UNION ALL
        SELECT *
        FROM tab3
        WHERE (a + b) * c = 18
    )
ORDER BY sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM tab
                        WHERE (a + b) * c = 8
                        UNION ALL
                        SELECT *
                        FROM tab3
                        WHERE (a + b) * c = 18
                    )
                ORDER BY sin(a / b) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%'
    OR `explain` LIKE '%ReadType%';

SELECT *
FROM (
        SELECT *
        FROM tab
        WHERE (a + b) * c = 8
        UNION ALL
        SELECT *
        FROM tab4
    )
ORDER BY sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM tab
                        WHERE (a + b) * c = 8
                        UNION ALL
                        SELECT *
                        FROM tab4
                    )
                ORDER BY sin(a / b) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%'
    OR `explain` LIKE '%ReadType%';

SELECT *
FROM (
        SELECT *
        FROM tab
        UNION ALL
        SELECT *
        FROM tab5
    )
ORDER BY (a + b) * c ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM tab
                        UNION ALL
                        SELECT *
                        FROM tab5
                    )
                ORDER BY (a + b) * c ASC
            ))
    )
WHERE `explain` LIKE '%sort description%'
    OR `explain` LIKE '%ReadType%';

SELECT *
FROM (
        SELECT *
        FROM tab
        UNION ALL
        SELECT *
        FROM tab5
    )
ORDER BY
    (a + b) * c ASC,
    sin(a / b) ASC;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM tab
                        UNION ALL
                        SELECT *
                        FROM tab5
                    )
                ORDER BY
                    (a + b) * c ASC,
                    sin(a / b) ASC
            ))
    )
WHERE `explain` LIKE '%sort description%'
    OR `explain` LIKE '%ReadType%';

-- Union with limit
SELECT *
FROM (
        SELECT *
        FROM tab
        UNION ALL
        SELECT *
        FROM tab5
    )
ORDER BY
    (a + b) * c ASC,
    sin(a / b) ASC
LIMIT 3;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM tab
                        UNION ALL
                        SELECT *
                        FROM tab5
                    )
                ORDER BY
                    (a + b) * c ASC,
                    sin(a / b) ASC
                LIMIT 3
            ))
    )
WHERE `explain` ILIKE '%sort description%'
    OR `explain` LIKE '%ReadType%'
    OR `explain` LIKE '%Limit%';

-- In this example, we read-in-order from tab up to ((a + b) * c, sin(a / b)) and from tab5 up to ((a + b) * c).
-- In case of tab5, there would be two finish sorting transforms: ((a + b) * c) -> ((a + b) * c, sin(a / b)) -> ((a + b) * c, sin(a / b), d).
-- It's important that ((a + b) * c) -> ((a + b) * c does not have LIMIT. We can add LIMIT WITH TIES later, when sorting alog support it.
-- In case of tab4, we do full sorting by ((a + b) * c, sin(a / b), d) with LIMIT. We can replace it to sorting by ((a + b) * c, sin(a / b)) and LIMIT WITH TIES, when sorting alog support it.
SELECT *
FROM (
        SELECT *
        FROM tab
        UNION ALL
        SELECT *
        FROM tab5
        UNION ALL
        SELECT *
        FROM tab4
    )
ORDER BY
    (a + b) * c ASC,
    sin(a / b) ASC,
    d ASC
LIMIT 3;

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT *
                FROM (
                        SELECT *
                        FROM tab
                        UNION ALL
                        SELECT *
                        FROM tab5
                        UNION ALL
                        SELECT *
                        FROM tab4
                    )
                ORDER BY
                    (a + b) * c ASC,
                    sin(a / b) ASC,
                    d ASC
                LIMIT 3
            ))
    )
WHERE `explain` ILIKE '%sort description%'
    OR `explain` LIKE '%ReadType%'
    OR `explain` LIKE '%Limit%';