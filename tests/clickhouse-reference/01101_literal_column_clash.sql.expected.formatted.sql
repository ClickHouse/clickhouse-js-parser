-- https://github.com/ClickHouse/ClickHouse/issues/9810
SELECT CAST(1 AS String)
FROM
    (
        SELECT 1 AS iid
    ) AS t1
INNER JOIN (
        SELECT '1' AS sid
    ) AS t2
    ON t2.sid = CAST(t1.iid AS String);

-- even simpler cases
SELECT
    CAST(7 AS String),
    *
FROM (
        SELECT 3 AS `'String'`
    );

SELECT
    CAST(7 AS String),
    *
FROM (
        SELECT number AS `'String'`
        FROM numbers(2)
    );

SELECT
    concat('xyz', 'abc'),
    *
FROM (
        SELECT 2 AS `'xyz'`
    );

WITH 3 AS `1`

SELECT
    1,
    `1`; -- { serverError AMBIGUOUS_COLUMN_NAME }

-- https://github.com/ClickHouse/ClickHouse/issues/9953
SELECT
    1,
    *
FROM
    (
        SELECT 2 AS x
    ) AS a
LEFT JOIN (
        SELECT
            1,
            3 AS y
    ) AS b
    ON y = x;

SELECT
    1,
    *
FROM
    (
        SELECT
            2 AS x,
            1
    ) AS a
RIGHT JOIN (
        SELECT 3 AS y
    ) AS b
    ON y = x;

SELECT
    NULL,
    isConstant(NULL),
    *
FROM
    (
        SELECT 2 AS x
    ) AS a
LEFT JOIN (
        SELECT
            NULL,
            3 AS y
    ) AS b
    ON y = x;

SELECT
    NULL,
    isConstant(NULL),
    *
FROM
    (
        SELECT
            2 AS x,
            NULL
    ) AS a
RIGHT JOIN (
        SELECT 3 AS y
    ) AS b
    ON y = x;

-- other cases with joins and constants
SELECT CAST(1 AS UInt8)
FROM
    (
        SELECT arrayJoin([1, 2]) AS a
    ) AS t1
LEFT JOIN (
        SELECT 1 AS b
    ) AS t2
    ON b = ignore('UInt8')
SETTINGS enable_analyzer = '0'; -- { serverError INVALID_JOIN_ON_EXPRESSION }

SELECT CAST(1 AS UInt8)
FROM
    (
        SELECT arrayJoin([1, 2]) AS a
    ) AS t1
LEFT JOIN (
        SELECT 1 AS b
    ) AS t2
    ON b = ignore('UInt8')
SETTINGS enable_analyzer = '1';

SELECT
    isConstant('UInt8'),
    toFixedString('hello', toUInt8(substring('UInt8', 5, 1)))
FROM
    (
        SELECT arrayJoin([1, 2]) AS a
    ) AS t1
LEFT JOIN (
        SELECT 1 AS b
    ) AS t2
    ON b = ignore('UInt8')
SETTINGS enable_analyzer = '0'; -- { serverError INVALID_JOIN_ON_EXPRESSION }

SELECT
    isConstant('UInt8'),
    toFixedString('hello', toUInt8(substring('UInt8', 5, 1)))
FROM
    (
        SELECT arrayJoin([1, 2]) AS a
    ) AS t1
LEFT JOIN (
        SELECT 1 AS b
    ) AS t2
    ON b = ignore('UInt8')
SETTINGS enable_analyzer = '1';

-- https://github.com/ClickHouse/ClickHouse/issues/20624
SELECT
    2 AS `toString(x)`,
    x
FROM (
        SELECT 1 AS x
    );