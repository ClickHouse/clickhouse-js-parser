DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    x UInt32
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8';

INSERT INTO t SELECT number
FROM numbers(100);

ALTER TABLE t ADD PROJECTION p (SELECT uniqHLL12(x));

INSERT INTO t SELECT number + 100
FROM numbers(100);

SELECT uniqHLL12(x)
FROM t
SETTINGS
    optimize_use_projections = '1',
    max_bytes_to_read = '400',
    max_block_size = '8'; -- { serverError TOO_MANY_BYTES }