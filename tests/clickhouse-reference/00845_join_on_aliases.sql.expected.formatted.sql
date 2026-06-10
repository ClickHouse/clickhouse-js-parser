DROP TABLE IF EXISTS table1;

DROP TABLE IF EXISTS table2;

CREATE TABLE table1
(
    a UInt32,
    b UInt32
)
ENGINE = Memory();

CREATE TABLE table2
(
    a UInt32,
    b UInt32
)
ENGINE = Memory();

INSERT INTO table1 SELECT
    number,
    number
FROM numbers(10);

INSERT INTO table2 SELECT
    number * 2,
    number * 20
FROM numbers(6);

SELECT
    t1.a AS t1_a,
    t2.a
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = table2.a
    AND t1.a = table2.a
    AND t1_a = table2.a
ORDER BY `all` ASC;

SELECT
    t1.a AS t1_a,
    t2.a
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = t2.a
    AND t1.a = t2.a
    AND t1_a = t2.a
ORDER BY `all` ASC;

SELECT
    t1.a AS t1_a,
    t2.a AS t2_a
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = t2_a
    AND t1.a = t2_a
    AND t1_a = t2_a
ORDER BY `all` ASC;

SELECT
    t1.a AS t1_a,
    t2.a
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = table2.a
    AND t1.a = t2.a
    AND t1_a = t2.a
ORDER BY `all` ASC;

SELECT
    t1.a AS t1_a,
    t2.a AS t2_a
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = table2.a
    AND t1.a = t2.a
    AND t1_a = t2_a
ORDER BY `all` ASC;

SELECT *
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1_a = t2_a
WHERE (table1.a AS t1_a) > 4
    AND (table2.a AS t2_a) > 2
ORDER BY `all` ASC;

SELECT
    t1.*,
    t2.*
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1_a = t2_a
WHERE (t1.a AS t1_a) > 2
    AND (t2.a AS t2_a) > 4
ORDER BY `all` ASC;

DROP TABLE table1;

DROP TABLE table2;