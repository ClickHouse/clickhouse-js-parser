DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS s;

CREATE TABLE t
(
    a Int64,
    b Int64,
    c String
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE s
(
    a Int64,
    b Int64,
    c String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t;

INSERT INTO s;

SELECT
    t.*,
    s.a,
    s.b,
    s.c
FROM
    t
LEFT JOIN s
    ON s.a = t.a
    AND s.b = t.b;

SELECT
    t.*,
    s.a,
    s.b,
    s.c
FROM
    t
RIGHT JOIN s
    ON s.a = t.a
    AND s.b = t.b;

SELECT
    t.*,
    s.a,
    s.b,
    s.c
FROM
    t
LEFT JOIN s
    ON s.a = t.a
    AND s.b = t.b
SETTINGS join_use_nulls = '1';

SELECT
    t.*,
    s.a,
    s.b,
    s.c
FROM
    t
RIGHT JOIN s
    ON s.a = t.a
    AND s.b = t.b
SETTINGS join_use_nulls = '1';

DROP TABLE t;

DROP TABLE s;

CREATE TABLE t
(
    a Int64,
    b Int64,
    c Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE s
(
    a Int64,
    b Int64,
    c Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

SELECT *
FROM
    t
LEFT JOIN s
    ON s.a = t.a
    AND s.b = t.b;

SELECT *
FROM
    t
RIGHT JOIN s
    ON s.a = t.a
    AND s.b = t.b;

SELECT
    t.*,
    s.*
FROM
    t
LEFT JOIN s
    ON s.a = t.a
    AND s.b = t.b
SETTINGS join_use_nulls = '1';

SELECT
    t.*,
    s.*
FROM
    t
RIGHT JOIN s
    ON s.a = t.a
    AND s.b = t.b
SETTINGS join_use_nulls = '1';

CREATE TABLE t
(
    a Int64,
    b Nullable(Int64),
    c String
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE s
(
    a Int64,
    b Nullable(Int64),
    c String
)
ENGINE = MergeTree()
ORDER BY tuple();

SELECT
    t.*,
    s.*
FROM
    t
LEFT JOIN s
    ON s.a = t.a
    AND s.b = t.b;

SELECT
    t.*,
    s.*
FROM
    t
RIGHT JOIN s
    ON s.a = t.a
    AND s.b = t.b;

SELECT *
FROM
    t
LEFT JOIN s
    ON s.a = t.a
    AND s.b = t.b
SETTINGS join_use_nulls = '1';

SELECT *
FROM
    t
RIGHT JOIN s
    ON s.a = t.a
    AND s.b = t.b
SETTINGS join_use_nulls = '1';

CREATE TABLE t
(
    a Int64,
    b Nullable(Int64),
    c Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE s
(
    a Int64,
    b Nullable(Int64),
    c Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE t
(
    a Nullable(Int64),
    b Nullable(Int64),
    c Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE s
(
    a Nullable(Int64),
    b Nullable(Int64),
    c Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();