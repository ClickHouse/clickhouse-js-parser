DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    x UInt32,
    lc LowCardinality(String)
)
ENGINE = Memory();

INSERT INTO t1;

SELECT
    toIntervalMinute(lc) AS e,
    toTypeName(e)
FROM t1;

SELECT
    toIntervalDay(lc) AS e,
    toTypeName(e)
FROM t1;

CREATE TABLE t2
(
    x UInt32,
    lc LowCardinality(String)
)
ENGINE = Memory();

INSERT INTO t2;

SELECT
    toUUID(lc) AS e,
    toTypeName(e)
FROM t2;

INSERT INTO t2;

SELECT
    toIntervalMinute(lc),
    toTypeName(materialize(r.lc))
FROM
    t1 AS l
INNER JOIN t2 AS r
    USING (lc);