SET flatten_nested = '1';

DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS mv;

CREATE TABLE t
(
    x int,
    y int,
    z int
)
ORDER BY x;

CREATE MATERIALIZED VIEW mv
ORDER BY ()
AS
SELECT
    x,
    [(y, z)]::Nested(y int, z int)
FROM t;

INSERT INTO t;

SELECT *
FROM mv;

DROP TABLE t;

DROP TABLE mv;

CREATE TABLE t
(
    x int,
    y Array(int),
    z Array(int)
)
ORDER BY x;

CREATE MATERIALIZED VIEW mv
ORDER BY ()
AS
SELECT
    x,
    arrayZip(y, z)::Nested(a int, b int) AS n
FROM t;

INSERT INTO t;

SELECT
    n.a[1],
    n.a[2],
    n.b[1],
    n.b[2]
FROM mv;