SET joined_subquery_requires_alias = '0';

DROP TABLE IF EXISTS tab1;

DROP TABLE IF EXISTS tab2;

DROP TABLE IF EXISTS tab3;

CREATE TABLE tab1
(
    a1 Int32,
    b1 Int32
)
ENGINE = MergeTree()
ORDER BY a1;

CREATE TABLE tab2
(
    a2 Int32,
    b2 Int32
)
ENGINE = MergeTree()
ORDER BY a2;

CREATE TABLE tab3
(
    a3 Int32,
    b3 Int32
)
ENGINE = MergeTree()
ORDER BY a3;

INSERT INTO tab1;

INSERT INTO tab2;

INSERT INTO tab2;

INSERT INTO tab3;

INSERT INTO tab3;

INSERT INTO tab3;

SELECT
    a2,
    b2
FROM
    tab2
ALL LEFT JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a2 ASC,
    b2 ASC;

SELECT
    a3,
    b3
FROM
    tab2
ALL LEFT JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a3 ASC,
    b3 ASC;

SELECT
    a2,
    b2,
    a3,
    b3
FROM
    tab2
ALL LEFT JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a2 ASC,
    b2 ASC,
    a3 ASC,
    b3 ASC;

SELECT a1
FROM
    tab1
ALL LEFT JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY a1 ASC;

SELECT
    a1,
    b2
FROM
    tab1
ALL LEFT JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a1 ASC,
    b2 ASC;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ALL LEFT JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a1 ASC,
    b1 ASC,
    a2 ASC,
    b2 ASC;

SELECT
    a2,
    b2 + 1
FROM
    tab1
ALL LEFT JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a2 ASC,
    b2 + 1 ASC;

SELECT
    a2,
    b2
FROM
    tab2
ALL RIGHT JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a2 ASC,
    b2 ASC;

SELECT
    a3,
    b3
FROM
    tab2
ALL RIGHT JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a3 ASC,
    b3 ASC;

SELECT
    a2,
    b2,
    a3,
    b3
FROM
    tab2
ALL RIGHT JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a2 ASC,
    b2 ASC,
    a3 ASC,
    b3 ASC;

SELECT a1
FROM
    tab1
ALL RIGHT JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY a1 ASC;

SELECT
    a1,
    b2
FROM
    tab1
ALL RIGHT JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a1 ASC,
    b2 ASC;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
ALL RIGHT JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a1 ASC,
    b1 ASC,
    a2 ASC,
    b2 ASC;

SELECT
    a2,
    b2 + 1
FROM
    tab1
ALL RIGHT JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a2 ASC,
    b2 + 1 ASC;

SELECT
    a2,
    b2
FROM
    tab2
FULL JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a2 ASC,
    b2 ASC;

SELECT
    a3,
    b3
FROM
    tab2
FULL JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a3 ASC,
    b3 ASC;

SELECT
    a2,
    b2,
    a3,
    b3
FROM
    tab2
FULL JOIN tab3
    ON a2 = a3
    OR b2 = b3
ORDER BY
    a2 ASC,
    b2 ASC,
    a3 ASC,
    b3 ASC;

SELECT a1
FROM
    tab1
FULL JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY a1 ASC;

SELECT
    a1,
    b2
FROM
    tab1
FULL JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a1 ASC,
    b2 ASC;

SELECT
    a1,
    b1,
    a2,
    b2
FROM
    tab1
FULL JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a1 ASC,
    b1 ASC,
    a2 ASC,
    b2 ASC;

SELECT
    a2,
    b2 + 1
FROM
    tab1
FULL JOIN tab2
    ON b1 + 1 = a2 + 1
    OR a1 + 4 = b2 + 2
ORDER BY
    a2 ASC,
    b2 + 1 ASC;

DROP TABLE tab1;

DROP TABLE tab2;

DROP TABLE tab3;