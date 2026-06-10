-- Tags: no-object-storage
-- Output slightly different plan
DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    a Int,
    b Int
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS index_granularity = '400';

INSERT INTO t SELECT
    0,
    0
FROM numbers(50);

INSERT INTO t SELECT
    0,
    1
FROM numbers(350);

INSERT INTO t SELECT
    1,
    2
FROM numbers(400);

INSERT INTO t SELECT
    2,
    2
FROM numbers(400);

INSERT INTO t SELECT
    3,
    0
FROM numbers(100);

SELECT sleep(1)
FORMAT Null; -- sleep a bit to wait possible merges after insert

SET max_threads = '1';

OPTIMIZE TABLE t FINAL;

SELECT sum(a)
FROM t
WHERE a IN (0, 3)
    AND b = 0;

DROP TABLE t;