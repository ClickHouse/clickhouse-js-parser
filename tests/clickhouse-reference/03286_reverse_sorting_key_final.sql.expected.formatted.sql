DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Nested(c1 Int)
)
ENGINE = SummingMergeTree()
ORDER BY (c0.c1 DESC)
SETTINGS allow_experimental_reverse_key = '1';

INSERT INTO t0 (c0.c1);

SELECT 1
FROM t0 FINAL;

DROP TABLE t0;

-- For consistency of the EXPLAIN output:
SET allow_prefetched_read_pool_for_remote_filesystem = '0';

-- PartsSplitter should work for reverse keys.
CREATE TABLE t0
(
    a Int,
    b Int
)
ENGINE = ReplacingMergeTree()
ORDER BY (a DESC, b DESC)
SETTINGS allow_experimental_reverse_key = '1', allow_nullable_key = '1', index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t0 SELECT
    number,
    number
FROM numbers(5);

INSERT INTO t0 SELECT
    number,
    number
FROM numbers(5, 2);

SET max_threads = '2';

EXPLAIN PIPELINE
SELECT *
FROM t0 FINAL
SETTINGS enable_vertical_final = '0';

-- PartsSplitter is disabled when some keys are in ascending order while others are in descending order.
CREATE TABLE t0
(
    a Int,
    b Int
)
ENGINE = ReplacingMergeTree()
ORDER BY (a DESC, b)
SETTINGS allow_experimental_reverse_key = '1', index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t0 SELECT
    number,
    number
FROM numbers(5, 2);