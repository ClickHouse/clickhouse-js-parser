SET enable_analyzer = '1';

SELECT
    [1] AS foo,
    [1] IN ([1] AS foo);

SELECT
    [isNaN(1)] AS foo,
    [1] IN ([isNaN(1)] AS foo);

CREATE TABLE tab
(
    c1 int
);

SELECT
    -(-c1 AS a2),
    NOT -(-c1 AS a2)
FROM tab;

DROP TABLE tab;

SELECT 'test'
SETTINGS max_query_size = '9223372036854775309';

SELECT
    (
        SELECT [1, 2, 3]
    ) AS a1,
    [5] IN ((
        SELECT [1, 2, 3]
    ) AS a1);

SELECT
    (
        SELECT 1
    ) AS a1,
    NOT((
        SELECT 1
    ) AS a1);

SELECT
    tuple(1, 'a') AS a1,
    tuple(1, 'a') IN (tuple(1, 'a') AS a1);

CREATE TABLE t1
(
    x int
);

CREATE TABLE t2
(
    x int
);

SELECT *
FROM
    t1
INNER JOIN t2
    ON t1.x = t2.x
    AND t1.x IS NULL AS e2;

DROP TABLE t1, t2;

SELECT
    tuple(1, 'a') AS a1,
    NOT(tuple(1, 'a') AS a1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

CREATE TABLE tab
(
    c1 int,
    c2 int,
    c3 int
);

CREATE TABLE tab2
(
    c1 int,
    c2 int,
    c3 int
);

INSERT INTO tab2 SELECT *
FROM tab
EXCEPT
SELECT *
FROM tab;

DROP TABLE tab2;

SELECT
    1,
    2,
    3
EXCEPT
SELECT
    1,
    2,
    3;