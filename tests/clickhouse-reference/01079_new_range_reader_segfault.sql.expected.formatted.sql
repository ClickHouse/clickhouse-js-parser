DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    a Int
)
ENGINE = MergeTree()
ORDER BY a;

-- some magic to satisfy conditions to run optimizations in MergeTreeRangeReader
INSERT INTO t SELECT number < 20 ? 0 : 1
FROM numbers(50);

ALTER TABLE t ADD COLUMN s String DEFAULT 'foo';

SELECT s
FROM t
PREWHERE a != 1
WHERE rowNumberInBlock() % 2 = 0
LIMIT 1;

DROP TABLE t;