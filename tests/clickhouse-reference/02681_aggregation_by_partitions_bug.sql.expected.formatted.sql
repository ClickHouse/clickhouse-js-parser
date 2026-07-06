-- Tags: no-random-merge-tree-settings
SET max_threads = '16';

CREATE TABLE t
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY a % 16;

INSERT INTO t SELECT *
FROM numbers_mt(1000000.);

SET allow_aggregate_partitions_independently = '1', force_aggregate_partitions_independently = '1';

SELECT countDistinct(a)
FROM t;