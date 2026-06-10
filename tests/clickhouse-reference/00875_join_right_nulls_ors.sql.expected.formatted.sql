DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS nt;

DROP TABLE IF EXISTS ntxy;

CREATE TABLE t
(
    x String
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE nt
(
    x Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE ntxy
(
    x Nullable(String),
    y Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t (x);

INSERT INTO nt (x);

INSERT INTO ntxy (x, y);

SET join_use_nulls = '1';

SELECT
    'n rj n',
    t1.x,
    t2.x
FROM
    nt AS t1
RIGHT JOIN ntxy AS t2
    ON t1.x = t2.x
    OR t1.x = t2.y
ORDER BY t1.x ASC;

SELECT
    'n a rj n',
    t1.x,
    t2.x
FROM
    nt AS t1
ANY RIGHT JOIN ntxy AS t2
    ON t1.x = t2.x
    OR t1.x = t2.y
ORDER BY t1.x ASC;

SELECT
    'n fj n',
    t1.x,
    t2.x
FROM
    nt AS t1
FULL JOIN ntxy AS t2
    ON t1.x = t2.x
    OR t1.x = t2.y
ORDER BY t1.x ASC;

SELECT
    't rj n',
    t1.x,
    t2.x
FROM
    t AS t1
RIGHT JOIN ntxy AS t2
    ON t1.x = t2.x
    OR t1.x = t2.y
ORDER BY t1.x ASC;

SELECT
    't fj n',
    t1.x,
    t2.x
FROM
    t AS t1
FULL JOIN ntxy AS t2
    ON t1.x = t2.x
    OR t1.x = t2.y
ORDER BY t1.x ASC;

SELECT
    'n rj t',
    t1.x,
    t2.x
FROM
    ntxy AS t1
RIGHT JOIN t AS t2
    ON t1.x = t2.x
    OR t1.y = t2.x
ORDER BY t1.x ASC;

SELECT
    'n a rj t',
    t1.x,
    t2.x
FROM
    ntxy AS t1
ANY RIGHT JOIN t AS t2
    ON t1.x = t2.x
    OR t1.y = t2.x
ORDER BY t1.x ASC;

SELECT
    'n fj t',
    t1.x,
    t2.x
FROM
    ntxy AS t1
FULL JOIN t AS t2
    ON t1.x = t2.x
    OR t2.x = t1.y
ORDER BY t1.x ASC;

SELECT
    'n fj t',
    t1.x,
    t2.x
FROM
    ntxy AS t1
FULL JOIN t AS t2
    ON t2.x = t1.y
    OR t1.x = t2.x
ORDER BY t1.x ASC;

DROP TABLE t;

DROP TABLE nt;

DROP TABLE ntxy;