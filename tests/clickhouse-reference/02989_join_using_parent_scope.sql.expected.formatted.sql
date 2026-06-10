DROP TABLE IF EXISTS tabc;

CREATE TABLE tabc
(
    a UInt32,
    b UInt32 ALIAS a + 1,
    c UInt32 ALIAS b + 1,
    s String
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO tabc (a, s) SELECT
    number,
    'abc' || toString(number)
FROM numbers(4);

DROP TABLE IF EXISTS ta;

CREATE TABLE ta
(
    a Int32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO ta SELECT number
FROM numbers(4);

DROP TABLE IF EXISTS tb;

CREATE TABLE tb
(
    b Int32
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tb SELECT number
FROM numbers(4);

SET join_use_nulls = '1';

SET analyzer_compatibility_join_using_top_level_identifier = '1';

-- { echoOn }
SELECT 1 AS c0
FROM
    (
        SELECT 1 AS c1
    ) AS t0
INNER JOIN (
        SELECT 1 AS c0
    ) AS t1
    USING (c0);

SELECT 1 AS c0
FROM
    (
        SELECT 1 AS c0
    ) AS t0
INNER JOIN (
        SELECT 1 AS c0
    ) AS t1
    USING (c0);

SELECT 1 AS a
FROM
    tb
INNER JOIN tabc
    USING (a)
ORDER BY `ALL` ASC;

SELECT a + 2 AS b
FROM
    ta
INNER JOIN tabc
    USING (b)
ORDER BY `ALL` ASC;

SELECT b + 2 AS a
FROM
    tb
INNER JOIN tabc
    USING (a)
ORDER BY `ALL` ASC;

SELECT a + 2 AS c
FROM
    ta
INNER JOIN tabc
    USING (c)
ORDER BY `ALL` ASC;

SELECT
    b AS a,
    a
FROM
    tb
INNER JOIN tabc
    USING (a)
ORDER BY `ALL` ASC;

SELECT 1 AS b
FROM
    tb
INNER JOIN ta
    USING (b); -- { serverError UNKNOWN_IDENTIFIER }

-- SELECT * returns all columns from both tables in new analyzer
SELECT
    3 AS a,
    a,
    *
FROM
    tb
FULL JOIN tabc
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    tb
INNER JOIN tabc
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    tb
LEFT JOIN tabc
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    tb
RIGHT JOIN tabc
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    tb
FULL JOIN tabc
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    tb
FULL JOIN tabc
    USING (a)
ORDER BY `ALL` ASC
SETTINGS
    asterisk_include_alias_columns = '1',
    enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    (
        SELECT b
        FROM tb
    ) AS t1
INNER JOIN (
        SELECT
            a,
            b
        FROM tabc
    ) AS t2
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    (
        SELECT b
        FROM tb
    ) AS t1
LEFT JOIN (
        SELECT
            a,
            b
        FROM tabc
    ) AS t2
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    (
        SELECT b
        FROM tb
    ) AS t1
RIGHT JOIN (
        SELECT
            a,
            b
        FROM tabc
    ) AS t2
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    *
FROM
    (
        SELECT b
        FROM tb
    ) AS t1
FULL JOIN (
        SELECT
            a,
            b
        FROM tabc
    ) AS t2
    USING (a)
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

SELECT
    b + 1 AS a,
    s
FROM
    tb
FULL JOIN tabc
    USING (a)
PREWHERE a > 2
ORDER BY `ALL` ASC
SETTINGS enable_analyzer = '1';

EXPLAIN PIPELINE
SELECT (
        SELECT 1
    ) AS c0
FROM
    (
        SELECT
            1 AS c0,
            1 AS c1
    ) AS tx
INNER JOIN (
        SELECT
            0 AS c0,
            1 AS c1
    ) AS ty
    USING (c0, c1)
FORMAT Null
SETTINGS enable_analyzer = '1';

-- It's a default behavior for old analyzer and new with analyzer_compatibility_join_using_top_level_identifier
-- Column `b` actually exists in left table, but `b` from USING is resoled to `a + 2` and `a` is not in left table
-- so we get UNKNOWN_IDENTIFIER error.
SELECT a + 2 AS b
FROM
    tb
INNER JOIN tabc
    USING (b)
ORDER BY `ALL` ASC
SETTINGS analyzer_compatibility_join_using_top_level_identifier = '1'; -- { serverError UNKNOWN_IDENTIFIER }

-- In new analyzer with `analyzer_compatibility_join_using_top_level_identifier = 0` we get `b` from left table
SELECT a + 2 AS b
FROM
    tb
INNER JOIN tabc
    USING (b)
ORDER BY `ALL` ASC
SETTINGS
    analyzer_compatibility_join_using_top_level_identifier = '0',
    enable_analyzer = '1';

-- This is example where query may return different results with different `analyzer_compatibility_join_using_top_level_identifier`
DROP TABLE IF EXISTS users;

CREATE TABLE users
(
    uid Int16,
    name String,
    spouse_name String
)
ENGINE = Memory();

INSERT INTO users;

INSERT INTO users;

SELECT
    u1.uid,
    u1.spouse_name AS name,
    u2.uid,
    u2.name
FROM
    users AS u1
INNER JOIN users AS u2
    USING (name)
ORDER BY u1.uid ASC
FORMAT TSVWithNamesAndTypes
SETTINGS enable_analyzer = '1', analyzer_compatibility_join_using_top_level_identifier = '1';

SELECT
    u1.uid,
    u1.spouse_name AS name,
    u2.uid,
    u2.name
FROM
    users AS u1
INNER JOIN users AS u2
    USING (name)
ORDER BY u1.uid ASC
FORMAT TSVWithNamesAndTypes
SETTINGS enable_analyzer = '1', analyzer_compatibility_join_using_top_level_identifier = '0';

SELECT
    u1.uid,
    u1.spouse_name AS name,
    u2.uid,
    u2.name
FROM
    users AS u1
INNER JOIN users AS u2
    USING (name)
ORDER BY u1.uid ASC
FORMAT TSVWithNamesAndTypes
SETTINGS enable_analyzer = '0';

DROP TABLE IF EXISTS tc;