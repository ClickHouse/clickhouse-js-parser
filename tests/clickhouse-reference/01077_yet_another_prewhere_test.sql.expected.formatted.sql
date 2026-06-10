DROP TABLE IF EXISTS t50;

CREATE TABLE t50
(
    a Int,
    b Int,
    s String
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS index_granularity = '50', index_granularity_bytes = '1000', min_index_granularity_bytes = '500';

-- some magic to satisfy conditions to run optimizations in MergeTreeRangeReader
INSERT INTO t50 SELECT
    0,
    1,
    repeat('a', 10000);

INSERT INTO t50 SELECT
    number,
    multiIf(number < 5, 1, number < 50, 0, number < 55, 1, number < 100, 0, number < 105, 1, 0),
    ''
FROM numbers(150);

OPTIMIZE TABLE t50 FINAL;

SELECT
    a,
    b
FROM t50
PREWHERE b = 1
ORDER BY a ASC;

DROP TABLE t50;