CREATE TABLE src
(
    y Int8
)
ENGINE = MergeTree()
ORDER BY y AS
SELECT 1;

SELECT 1
FROM (
        SELECT 2
        FROM src
    )
SETTINGS
    enable_parallel_replicas = '1',
    max_parallel_replicas = '2',
    cluster_for_parallel_replicas = 'test_shard_localhost',
    parallel_replicas_for_non_replicated_merge_tree = '1';