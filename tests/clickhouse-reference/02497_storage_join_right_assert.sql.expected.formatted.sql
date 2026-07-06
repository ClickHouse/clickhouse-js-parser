DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    key UInt64,
    a UInt64
)
ENGINE = Memory();

CREATE TABLE t2
(
    key UInt64,
    a UInt64
)
ENGINE = Join(`ALL`, `RIGHT`, key);

INSERT INTO t1;

INSERT INTO t2;

SET enable_analyzer = '0';

SELECT *
FROM
    t1
ALL RIGHT JOIN t2
    USING (key)
ORDER BY key ASC;

SET enable_analyzer = '1';