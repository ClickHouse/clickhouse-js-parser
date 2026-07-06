DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

DROP TABLE IF EXISTS t3;

CREATE TABLE t1
(
    a UInt32,
    b String
)
ENGINE = Memory();

CREATE TABLE t2
(
    c UInt32,
    d String
)
ENGINE = Memory();

CREATE TABLE t3
(
    a UInt32
)
ENGINE = Memory();

INSERT INTO t1;

INSERT INTO t2;

INSERT INTO t3;

SET enable_optimize_predicate_expression = '0';

SELECT *
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT *
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    t1.a,
    t2.c
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT
    t1.a,
    t2.c
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    t1.b,
    t2.d
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT
    t1.b,
    t2.d
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    a,
    c
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT
    a,
    c
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    b,
    d
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT
    b,
    d
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    b AS a,
    d AS c
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT
    b AS a,
    d AS c
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    b AS c,
    d AS a
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT
    b AS c,
    d AS a
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    t1.a AS a,
    t2.c AS c
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT
    t1.a AS a,
    t2.c AS c
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    t1.a AS c,
    t2.c AS a
FROM
    t1
INNER JOIN t2
    ON a = c;

SELECT
    t1.a AS c,
    t2.c AS a
FROM
    t1
INNER JOIN t2
    ON c = a;

SELECT
    t1.a AS c,
    t2.c AS a
FROM
    t1
INNER JOIN t2
    ON t1.a = t2.c;

SELECT
    t1.a AS c,
    t2.c AS a
FROM
    t1
INNER JOIN t2
    ON t2.c = t1.a;

SELECT
    t1.a,
    t3.a
FROM
    t1
INNER JOIN t3
    ON t1.a = t3.a;

SELECT
    t1.a AS t1_a,
    t3.a AS t3_a
FROM
    t1
INNER JOIN t3
    ON t1_a = t3_a;

SELECT
    table1.a AS t1_a,
    table3.a AS t3_a
FROM
    t1 AS table1
INNER JOIN t3 AS table3
    ON t1_a = t3_a;

SET enable_optimize_predicate_expression = '1';

DROP TABLE t1;

DROP TABLE t2;

DROP TABLE t3;