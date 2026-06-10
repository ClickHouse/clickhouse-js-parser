CREATE TABLE t1
(
    a Int,
    b Int
)
ENGINE = Memory();

INSERT INTO t1;

CREATE TABLE t2
(
    a Int,
    b Nullable(Int)
)
ENGINE = Memory();

INSERT INTO t2;

-- { echoOn }
SELECT *
FROM
    t1
ASOF INNER JOIN t2
    ON t1.a = t2.a
    AND t1.b < t2.b
ORDER BY t1.b ASC;

SELECT *
FROM
    t1
ASOF INNER JOIN t2
    ON t1.a = t2.a
    AND t1.b <= t2.b
ORDER BY t1.b ASC;

SELECT *
FROM
    t1
ASOF INNER JOIN t2
    ON t1.a = t2.a
    AND t1.b > t2.b
ORDER BY t1.b ASC;

SELECT *
FROM
    t1
ASOF INNER JOIN t2
    ON t1.a = t2.a
    AND t1.b >= t2.b
ORDER BY t1.b ASC;

SELECT *
FROM
    t1
ASOF LEFT JOIN t2
    ON t1.a = t2.a
    AND t1.b < t2.b
ORDER BY t1.b ASC;

SELECT *
FROM
    t1
ASOF LEFT JOIN t2
    ON t1.a = t2.a
    AND t1.b <= t2.b
ORDER BY t1.b ASC;

SELECT *
FROM
    t1
ASOF LEFT JOIN t2
    ON t1.a = t2.a
    AND t1.b > t2.b
ORDER BY t1.b ASC;

SELECT *
FROM
    t1
ASOF LEFT JOIN t2
    ON t1.a = t2.a
    AND t1.b >= t2.b
ORDER BY t1.b ASC;

SET join_use_nulls = '1';

DROP TABLE t1;