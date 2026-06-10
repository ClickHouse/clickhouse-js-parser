-- Tags: shard
CREATE TABLE IF NOT EXISTS local_01213
(
    id Int
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE IF NOT EXISTS dist_01213 AS local_01213
ENGINE = Distributed(test_cluster_two_shards_localhost, currentDatabase(), local_01213, id);

-- at least two parts
INSERT INTO local_01213 SELECT toString(number)
FROM numbers(2);

SELECT DISTINCT id
FROM dist_01213
WHERE id = 1
SETTINGS distributed_group_by_no_merge = '1';

SELECT DISTINCT id
FROM dist_01213
WHERE id = 1
SETTINGS optimize_skip_unused_shards = '1';

SELECT DISTINCT id
FROM dist_01213
SETTINGS
    optimize_skip_unused_shards = '1',
    optimize_distributed_group_by_sharding_key = '0';

SELECT DISTINCT id
FROM dist_01213
SETTINGS
    optimize_skip_unused_shards = '1',
    optimize_distributed_group_by_sharding_key = '1';

DROP TABLE local_01213;

DROP TABLE dist_01213;