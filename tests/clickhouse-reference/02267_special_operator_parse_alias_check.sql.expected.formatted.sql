-- CAST expression
-- cast(expr [[AS] alias_1] AS Type)
SELECT CAST('1234' AS UInt32);

SELECT
    CAST('1234' AS lhs AS UInt32),
    lhs;

SELECT
    CAST('1234' AS lhs AS UInt32),
    lhs;

SELECT
    CAST('1234' AS lhs AS UInt32),
    lhs;

SELECT
    CAST('1234' AS rhs AS UInt32),
    rhs;

SELECT
    CAST('1234' AS rhs AS UInt32),
    rhs;

-- cast(expr [[AS] alias_1], type_expr [[as] alias_2])
SELECT CAST('1234' AS UInt32);

SELECT
    CAST('1234' AS lhs AS UInt32),
    lhs;

SELECT
    CAST('1234' AS lhs AS UInt32),
    lhs;

SELECT
    CAST('1234', 'UInt32' AS rhs),
    rhs;

SELECT
    CAST('1234', 'UInt32' AS rhs),
    rhs;

SELECT
    CAST('1234' AS lhs, 'UInt32' AS rhs),
    lhs,
    rhs;

SELECT
    CAST('1234' AS lhs, 'UInt32' AS rhs),
    lhs,
    rhs;

-- SUBSTRING expression
-- SUBSTRING(expr FROM start)
SELECT substring('1234', 2);

SELECT
    substring('1234' AS lhs, 2),
    lhs;

SELECT
    substring('1234' AS lhs, 2),
    lhs;

SELECT
    substring('1234', 2 AS rhs),
    rhs;

SELECT
    substring('1234', 2 AS rhs),
    rhs;

SELECT
    substring('1234' AS lhs, 2 AS rhs),
    lhs,
    rhs;

SELECT
    substring('1234' AS lhs, 2 AS rhs),
    lhs,
    rhs;

SELECT
    substring('1234' AS lhs, 2 AS rhs),
    lhs,
    rhs;

-- SUBSTRING(expr FROM start FOR length)
SELECT substring('1234', 2, 2);

SELECT
    substring('1234', 2, 2 AS lhs),
    lhs;

SELECT
    substring('1234', 2, 2 AS lhs),
    lhs;

-- SUBSTRING(expr, start, length)
SELECT
    substring('1234' AS arg_1, 2 AS arg_2, 3 AS arg_3),
    arg_1,
    arg_2,
    arg_3;

SELECT
    substring('1234' AS arg_1, 2 AS arg_2, 3 AS arg_3),
    arg_1,
    arg_2,
    arg_3;

-- -- TRIM expression ([[LEADING|TRAILING|BOTH] trim_character FROM] input_string)
SELECT
    trimLeft('abca' AS arg_2, 'a' AS arg_1),
    arg_1,
    arg_2;

SELECT
    trimLeft('abca' AS arg_2, 'a' AS arg_1),
    arg_1,
    arg_2;

SELECT
    trimLeft('abca' AS arg_2, 'a'),
    arg_2;

SELECT
    trimLeft('abca' AS arg_2, 'a'),
    arg_2;

SELECT
    trimLeft('abca', 'a' AS arg_1),
    arg_1;

SELECT
    trimLeft('abca', 'a' AS arg_1),
    arg_1;

SELECT trimLeft('abca', 'a');

SELECT
    trimRight('abca' AS arg_2, 'a' AS arg_1),
    arg_1,
    arg_2;

SELECT
    trimRight('abca' AS arg_2, 'a' AS arg_1),
    arg_1,
    arg_2;

SELECT
    trimBoth('abca' AS arg_2, 'a' AS arg_1),
    arg_1,
    arg_2;

SELECT
    trimBoth('abca' AS arg_2, 'a' AS arg_1),
    arg_1,
    arg_2;

-- Bug #69922
SELECT trimLeft('abc', concat(''));

SELECT trimLeft('abc', concat('a', 'b'));

-- EXTRACT expression
-- EXTRACT(part FROM date)
SELECT
    toDayOfMonth(toDate('2019-05-05') AS arg_1),
    arg_1;

SELECT
    toDayOfMonth(toDate('2019-05-05') AS arg_1),
    arg_1;

-- Function extract(haystack, pattern)
SELECT
    extract('1234' AS arg_1, '123' AS arg_2),
    arg_1,
    arg_2;

SELECT
    extract('1234' AS arg_1, '123' AS arg_2),
    arg_1,
    arg_2;

-- POSITION expression
-- position(needle IN haystack)
SELECT
    position('1234' AS arg_2, '123' AS arg_1),
    arg_1,
    arg_2;

-- position(haystack, needle[, start_pos])
SELECT
    position('123' AS arg_1, '1234' AS arg_2),
    arg_1,
    arg_2;

SELECT
    position('123' AS arg_1, '1234' AS arg_2),
    arg_1,
    arg_2;

-- dateAdd, dateSub expressions
-- function(unit, offset, timestamp)
SELECT
    plus(toDate('2019-05-05') AS arg_2, toIntervalDay(1 AS arg_1)),
    arg_1,
    arg_2;

SELECT
    plus(toDate('2019-05-05') AS arg_2, toIntervalDay(1 AS arg_1)),
    arg_1,
    arg_2;

-- function(unit, offset, timestamp)
SELECT
    minus(toDate('2019-05-05') AS arg_2, toIntervalDay(1 AS arg_1)),
    arg_1,
    arg_2;

SELECT
    minus(toDate('2019-05-05') AS arg_2, toIntervalDay(1 AS arg_1)),
    arg_1,
    arg_2;

-- dateDiff expression
-- dateDiff(unit, startdate, enddate, [timezone])
SELECT
    dateDiff('day', toDate('2019-05-05') AS arg_1, toDate('2019-05-06') AS arg_2),
    arg_1,
    arg_2;

SELECT
    dateDiff('day', toDate('2019-05-05') AS arg_1, toDate('2019-05-06') AS arg_2),
    arg_1,
    arg_2;

SELECT
    dateDiff('day', toDate('2019-05-05') AS arg_1, toDate('2019-05-06') AS arg_2, 'UTC'),
    arg_1,
    arg_2;

SELECT
    dateDiff('day', toDate('2019-05-05') AS arg_1, toDate('2019-05-06') AS arg_2, 'UTC'),
    arg_1,
    arg_2;

-- dateDiff('unit', startdate, enddate, [timezone])
SELECT
    dateDiff('DAY', toDate('2019-05-05') AS arg_1, toDate('2019-05-06') AS arg_2),
    arg_1,
    arg_2;

SELECT
    dateDiff('DAY', toDate('2019-05-05') AS arg_1, toDate('2019-05-06') AS arg_2),
    arg_1,
    arg_2;

SELECT
    dateDiff('DAY', toDate('2019-05-05') AS arg_1, toDate('2019-05-06') AS arg_2, 'UTC'),
    arg_1,
    arg_2;

SELECT
    dateDiff('DAY', toDate('2019-05-05') AS arg_1, toDate('2019-05-06') AS arg_2, 'UTC'),
    arg_1,
    arg_2;