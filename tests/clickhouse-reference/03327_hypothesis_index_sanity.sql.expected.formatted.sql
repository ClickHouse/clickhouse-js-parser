CREATE TABLE t3
(
    x UInt8,
    INDEX i x TYPE hypothesis() GRANULARITY 100
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1';

INSERT INTO t3;

SELECT 1
FROM t3
WHERE x = 1;

CREATE TABLE t0
(
    c0 Int,
    INDEX i0 c0 TYPE hypothesis() GRANULARITY 9
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '4';

INSERT INTO t0 (c0);

SELECT 1
FROM
    t0 AS tx
INNER JOIN t0
    ON tx.c0 = t0.c0;