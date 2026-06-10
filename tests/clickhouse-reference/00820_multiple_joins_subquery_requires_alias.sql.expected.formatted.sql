SET enable_analyzer = '1';

DROP TABLE IF EXISTS table1;

DROP TABLE IF EXISTS table2;

DROP TABLE IF EXISTS table3;

DROP TABLE IF EXISTS table5;

CREATE TABLE table1
(
    a UInt32
)
ENGINE = Memory();

CREATE TABLE table2
(
    a UInt32,
    b UInt32
)
ENGINE = Memory();

CREATE TABLE table3
(
    b UInt32,
    c UInt32
)
ENGINE = Memory();

CREATE TABLE table5
(
    a UInt32,
    b UInt32,
    c UInt32
)
ENGINE = Memory();

INSERT INTO table1 SELECT number
FROM numbers(21);

INSERT INTO table2 SELECT
    number * 2,
    number * 20
FROM numbers(11);

INSERT INTO table3 SELECT
    number * 30,
    number * 300
FROM numbers(10);

INSERT INTO table5 SELECT
    number * 5,
    number * 50,
    number * 500
FROM numbers(10);

SET joined_subquery_requires_alias = '1';

SELECT
    t1.a,
    t2.b,
    t3.c
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1.a = t2.a
INNER JOIN table3 AS t3
    ON t2.b = t3.b
ORDER BY t1.a ASC;

SELECT
    t1.a,
    t2.b,
    t5.c
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1.a = t2.a
INNER JOIN table5 AS t5
    ON t1.a = t5.a
    AND t2.b = t5.b
ORDER BY t1.a ASC;

SELECT
    t1.a,
    t2.a,
    t2.b,
    t3.b,
    t3.c,
    t5.a,
    t5.b,
    t5.c
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1.a = t2.a
INNER JOIN table3 AS t3
    ON t2.b = t3.b
INNER JOIN table5 AS t5
    ON t3.c = t5.c
ORDER BY t1.a ASC
FORMAT PrettyCompactNoEscapes;

SELECT
    t1.a AS t1_a,
    t2.a AS t2_a,
    t2.b AS t2_b,
    t3.b AS t3_b
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1_a = t2_a
INNER JOIN table3 AS t3
    ON t2_b = t3_b
ORDER BY t1.a ASC;

SELECT
    t1.a AS t1_a,
    t2.a AS t2_a,
    t2.b AS t2_b,
    t3.b AS t3_b
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1.a = t2.a
INNER JOIN table3 AS t3
    ON t2.b = t3.b
ORDER BY t1.a ASC;

SELECT
    t1.a AS t1_a,
    t2.a AS t2_a,
    t2.b AS t2_b,
    t3.b AS t3_b
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = table2.a
INNER JOIN table3 AS t3
    ON table2.b = table3.b
ORDER BY t1.a ASC;

SELECT
    t1.a,
    t2.a,
    t2.b,
    t3.b
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = table2.a
INNER JOIN table3 AS t3
    ON table2.b = table3.b
ORDER BY t1.a ASC;

SELECT
    t1.a,
    t2.a,
    t2.b,
    t3.b
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1.a = t2.a
INNER JOIN table3 AS t3
    ON t2.b = t3.b
ORDER BY t1.a ASC;

SELECT
    table1.a,
    table2.a,
    table2.b,
    table3.b
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = table2.a
INNER JOIN table3 AS t3
    ON table2.b = table3.b
ORDER BY t1.a ASC;

SELECT
    t1.*,
    t2.*,
    t3.*
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON table1.a = table2.a
INNER JOIN table3 AS t3
    ON table2.b = table3.b
ORDER BY t1.a ASC
FORMAT PrettyCompactNoEscapes;

SELECT *
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1.a = t2.a
INNER JOIN table3 AS t3
    ON t2.b = t3.b
ORDER BY t1.a ASC
FORMAT PrettyCompactNoEscapes;

SELECT
    t1.a AS t1_a,
    t2.a AS t2_a,
    t2.b AS t2_b,
    t3.b AS t3_b,
    t1.a + table2.b AS t1_t2_x,
    table1.a + table3.b AS t1_t3_x,
    t2.b + t3.b AS t2_t3_x
FROM
    table1 AS t1
INNER JOIN table2 AS t2
    ON t1_a = t2_a
INNER JOIN table3 AS t3
    ON t2_b = t3_b
ORDER BY t1.a ASC;

DROP TABLE table1;

DROP TABLE table2;

DROP TABLE table3;

DROP TABLE table5;