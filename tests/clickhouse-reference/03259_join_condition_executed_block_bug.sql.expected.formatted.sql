DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    key String,
    attr String,
    a UInt64,
    b UInt64,
    c Nullable(UInt64)
)
ENGINE = MergeTree()
ORDER BY key;

CREATE TABLE t2
(
    key String,
    attr String,
    a UInt64,
    b UInt64,
    c Nullable(UInt64)
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO t1;

INSERT INTO t2;

SET allow_experimental_join_condition = true;

SET enable_analyzer = true;

SELECT t1.*
FROM
    t1
FULL JOIN t2
    ON t1.key = t2.key
    AND (t1.a = 2
    OR indexHint(t2.a = 2))
FORMAT Null;