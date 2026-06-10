-- Tags: distributed, no-parallel
SET send_logs_level = 'error';

CREATE DATABASE IF NOT EXISTS shard_0;

CREATE DATABASE IF NOT EXISTS shard_1;

DROP TABLE IF EXISTS shard_0.shard_01231_distributed_aggregation_memory_efficient;

DROP TABLE IF EXISTS shard_1.shard_01231_distributed_aggregation_memory_efficient;

DROP TABLE IF EXISTS ma_dist;

CREATE TABLE shard_0.shard_01231_distributed_aggregation_memory_efficient
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY x;

CREATE TABLE shard_1.shard_01231_distributed_aggregation_memory_efficient
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO shard_0.shard_01231_distributed_aggregation_memory_efficient SELECT *
FROM numbers(1);

INSERT INTO shard_1.shard_01231_distributed_aggregation_memory_efficient SELECT *
FROM numbers(10);

CREATE TABLE ma_dist
(
    x UInt64
)
ENGINE = Distributed(test_cluster_two_shards_different_databases, '', 'shard_01231_distributed_aggregation_memory_efficient');

SET distributed_aggregation_memory_efficient = '1';

SET group_by_two_level_threshold = '2';

SET max_bytes_before_external_group_by = '16';

SET max_bytes_ratio_before_external_group_by = '0';

SELECT
    x,
    count()
FROM ma_dist
GROUP BY x
ORDER BY x ASC;

SELECT arrayFilter((y -> y = x), [x]) AS f
FROM ma_dist
ORDER BY f ASC;

DROP TABLE ma_dist;

DROP DATABASE shard_0;

DROP DATABASE shard_1;