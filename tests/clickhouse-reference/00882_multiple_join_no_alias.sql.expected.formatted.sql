DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS s;

DROP TABLE IF EXISTS y;

CREATE TABLE t
(
    a Int64,
    b Int64
)
ENGINE = Memory();

CREATE TABLE s
(
    a Int64,
    b Int64
)
ENGINE = Memory();

CREATE TABLE y
(
    a Int64,
    b Int64
)
ENGINE = Memory();

INSERT INTO t;

INSERT INTO s;

INSERT INTO y;

SELECT
    s.a,
    s.a,
    s.b AS s_b,
    s.b
FROM
    t
LEFT JOIN s
    ON s.a = t.a
LEFT JOIN y
    ON s.b = y.b
ORDER BY
    t.a ASC,
    s.a ASC,
    s.b ASC;

SELECT max(s.a)
FROM
    t
LEFT JOIN s
    ON s.a = t.a
LEFT JOIN y
    ON s.b = y.b
GROUP BY t.a
ORDER BY t.a ASC;

SELECT
    t.a,
    t.a AS t_a,
    s.a,
    s.a AS s_a,
    y.a,
    y.a AS y_a
FROM
    t
LEFT JOIN s
    ON t.a = s.a
LEFT JOIN y
    ON y.b = s.b
ORDER BY
    t.a ASC,
    s.a ASC,
    y.a ASC;

SELECT
    t.a,
    t.a AS t_a,
    max(s.a)
FROM
    t
LEFT JOIN s
    ON t.a = s.a
LEFT JOIN y
    ON y.b = s.b
GROUP BY t.a
ORDER BY t.a ASC;

DROP TABLE t;

DROP TABLE s;

DROP TABLE y;