DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    x UInt32,
    s String
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE t2
(
    x UInt32,
    s String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t1 (x, s);

INSERT INTO t2 (x, s);

SET join_use_nulls = '0';

SELECT
    t1.*,
    t2.*
FROM
    t1
SEMI LEFT JOIN t2
    USING (x)
ORDER BY
    t1.x ASC,
    t2.x ASC,
    t1.s ASC,
    t2.s ASC;

SELECT
    t1.*,
    t2.*
FROM
    t1
SEMI RIGHT JOIN t2
    USING (x)
ORDER BY
    t1.x ASC,
    t2.x ASC,
    t1.s ASC,
    t2.s ASC;

SELECT
    t1.*,
    t2.*
FROM
    t1
ANTI LEFT JOIN t2
    USING (x)
ORDER BY
    t1.x ASC,
    t2.x ASC,
    t1.s ASC,
    t2.s ASC;

SELECT
    t1.*,
    t2.*
FROM
    t1
ANTI RIGHT JOIN t2
    USING (x)
ORDER BY
    t1.x ASC,
    t2.x ASC,
    t1.s ASC,
    t2.s ASC;

DROP TABLE t1;

DROP TABLE t2;