DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    x Decimal(18, 3)
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO t;

SELECT *
FROM t
WHERE toUInt64(x) = 1;

DROP TABLE t;

CREATE TABLE t
(
    x DateTime64(3)
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO t;

SELECT x::UInt64
FROM t
WHERE toUInt64(x) = 1;