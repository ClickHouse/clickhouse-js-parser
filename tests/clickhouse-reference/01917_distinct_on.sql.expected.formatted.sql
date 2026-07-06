DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    a UInt32,
    b UInt32,
    c UInt32
)
ENGINE = Memory();

INSERT INTO t1;

SELECT
    a,
    b,
    c
FROM t1
LIMIT 1 BY a, b;

SELECT *
FROM t1
LIMIT 1 BY a, b;

SELECT *
FROM t1
LIMIT 1 BY a;