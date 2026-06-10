DROP TABLE IF EXISTS da_memory_efficient_shard;

CREATE TABLE da_memory_efficient_shard
(
    A Int64,
    B Int64
)
ENGINE = MergeTree()
ORDER BY A
PARTITION BY B % 2;

INSERT INTO da_memory_efficient_shard SELECT
    number,
    number
FROM numbers(100000);

SET distributed_aggregation_memory_efficient = '1', group_by_two_level_threshold = '1', group_by_two_level_threshold_bytes = '1';

SELECT sum(a)
FROM (
        SELECT
            B,
            uniqExact(A) AS a
        FROM remote('localhost,127.0.0.1', currentDatabase(), da_memory_efficient_shard)
        GROUP BY B
    );