DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    n UInt32,
    x UInt32,
    y UInt32,
    z UInt32,
    PROJECTION p (SELECT count() GROUP BY x, z)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT
    number,
    number % 3,
    number % 5,
    number % 7
FROM numbers_mt(30);

SELECT DISTINCT
    x,
    z
FROM tab;

EXPLAIN
SELECT DISTINCT
    x,
    z
FROM tab;

SELECT DISTINCT z
FROM tab;

EXPLAIN
SELECT DISTINCT z
FROM tab;

SELECT DISTINCT
    x,
    y
FROM tab;

EXPLAIN
SELECT DISTINCT
    x,
    y
FROM tab;

SELECT DISTINCT
    x,
    z
FROM tab
WHERE x IN (1, 2)
    AND z < 5;

EXPLAIN
SELECT DISTINCT
    x,
    z
FROM tab
WHERE x IN (1, 2)
    AND z < 5;

CREATE TABLE tab
(
    n UInt32,
    x UInt32,
    y UInt32,
    PROJECTION p (SELECT count() GROUP BY x / 2, y % 10)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT
    number,
    number % 3,
    number % 5
FROM numbers_mt(30);

SELECT DISTINCT
    x / 2,
    y % 10
FROM tab;

EXPLAIN
SELECT DISTINCT
    x / 2,
    y % 10
FROM tab;

SELECT DISTINCT x / 2
FROM tab;

EXPLAIN
SELECT DISTINCT x / 2
FROM tab;

SELECT DISTINCT
    x / 2,
    y
FROM tab;

EXPLAIN
SELECT DISTINCT
    x / 2,
    y
FROM tab;