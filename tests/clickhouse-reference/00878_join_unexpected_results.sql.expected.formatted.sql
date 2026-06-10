DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS s;

CREATE TABLE t
(
    a Int64,
    b Int64
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE s
(
    a Int64,
    b Int64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t;

INSERT INTO s;

SET join_use_nulls = '1';

SELECT *
FROM
    t
LEFT JOIN s
    USING (a, b)
ORDER BY t.a ASC;

SELECT *
FROM
    t
INNER JOIN s
    USING (a, b);

SELECT *
FROM
    t
INNER JOIN s
    ON t.a = s.a
    AND t.b = s.b;

SELECT t.*
FROM
    t
LEFT JOIN s
    ON t.a = s.a
    AND t.b = s.b
ORDER BY t.a ASC;

SELECT
    t.*,
    s.*
FROM
    t
LEFT JOIN s
    ON t.a = s.a
    AND t.b = s.b
ORDER BY t.a ASC;

SELECT
    t.*,
    s.*
FROM
    t
LEFT JOIN s
    ON s.a = t.a
    AND t.b = s.b
ORDER BY t.a ASC;

SELECT
    t.*,
    s.*
FROM
    t
RIGHT JOIN s
    ON t.a = s.a
    AND t.b = s.b;

SELECT *
FROM
    t
LEFT JOIN s
    USING (a, b)
WHERE s.a IS NULL;

SELECT *
FROM
    t
LEFT JOIN s
    ON t.a = s.a
    AND t.b = s.b
WHERE s.a IS NULL;

SELECT s.*
FROM
    t
LEFT JOIN s
    ON t.a = s.a
    AND t.b = s.b
WHERE s.a IS NULL;

SELECT
    t.*,
    s.*
FROM
    t
LEFT JOIN s
    ON s.a = t.a
    AND t.b = s.b
    AND t.a = toInt64(2)
ORDER BY t.a ASC;

SELECT
    t.*,
    s.*
FROM
    t
LEFT JOIN s
    ON s.a = t.a
ORDER BY t.a ASC;

SELECT
    t.*,
    s.*
FROM
    t
LEFT JOIN s
    ON t.b = toInt64(1)
    AND s.a = t.a
WHERE s.b = 1;

SELECT
    t.*,
    s.*
FROM
    t
LEFT JOIN s
    ON t.b = toInt64(2)
    AND s.a = t.a
WHERE t.b = 2;

SET join_use_nulls = '0';

DROP TABLE t;

DROP TABLE s;