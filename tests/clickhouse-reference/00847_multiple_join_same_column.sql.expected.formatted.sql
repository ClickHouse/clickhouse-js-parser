DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS s;

DROP TABLE IF EXISTS y;

CREATE TABLE t
(
    a Int64,
    b Int64
)
ENGINE = TinyLog();

CREATE TABLE s
(
    a Int64,
    b Int64
)
ENGINE = TinyLog();

CREATE TABLE y
(
    a Int64,
    b Int64
)
ENGINE = TinyLog();

INSERT INTO t;

INSERT INTO s;

INSERT INTO y;

SELECT
    t.a,
    s.b,
    s.a,
    s.b,
    y.a,
    y.b
FROM
    t
LEFT JOIN s
    ON t.a = s.a
    AND t.b = s.b
LEFT JOIN y
    ON y.a = s.a
    AND y.b = s.b
ORDER BY t.a ASC
FORMAT Vertical;

SELECT
    t.a,
    s.b,
    s.a,
    s.b,
    y.a,
    y.b
FROM
    t
LEFT JOIN s
    ON t.a = s.a
    AND s.b = t.b
LEFT JOIN y
    ON y.a = s.a
    AND y.b = s.b
ORDER BY t.a ASC
FORMAT PrettyCompactMonoBlock;

SELECT t.a AS t_a
FROM
    t
LEFT JOIN s
    ON s.a = t_a
ORDER BY t.a ASC
FORMAT PrettyCompactMonoBlock;

SELECT
    t.a,
    s.a AS s_a
FROM
    t
LEFT JOIN s
    ON s.a = t.a
LEFT JOIN y
    ON y.b = s.b
ORDER BY t.a ASC
FORMAT PrettyCompactMonoBlock;

SELECT
    t.a,
    t.a,
    t.b AS t_b
FROM
    t
LEFT JOIN s
    ON t.a = s.a
LEFT JOIN y
    ON y.b = s.b
ORDER BY t.a ASC
FORMAT PrettyCompactMonoBlock;

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
ORDER BY t.a ASC
FORMAT PrettyCompactMonoBlock;

SELECT
    y.a,
    y.a,
    y.b AS y_b,
    y.b
FROM
    t
LEFT JOIN s
    ON s.a = t.a
LEFT JOIN y
    ON y.b = s.b
ORDER BY t.a ASC
FORMAT PrettyCompactMonoBlock;

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
ORDER BY t.a ASC
FORMAT PrettyCompactMonoBlock;

DROP TABLE t;

DROP TABLE s;

DROP TABLE y;