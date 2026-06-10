DROP TABLE IF EXISTS pr_t;

CREATE TABLE pr_t
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY a;

ALTER TABLE pr_t ADD PROJECTION p_agg (SELECT a, sum(b) GROUP BY a);

INSERT INTO pr_t SELECT
    number % 1000,
    number % 1000
FROM numbers_mt(1000000.);

SET parallel_replicas_only_with_analyzer = '0'; -- necessary for CI run with disabled analyzer

SET max_threads = '4';

SET enable_parallel_replicas = '1', parallel_replicas_for_non_replicated_merge_tree = '1', max_parallel_replicas = '3', cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost';

SET distributed_aggregation_memory_efficient = '1', enable_memory_bound_merging_of_aggregation_results = '1';

SET enable_analyzer = '1', parallel_replicas_local_plan = '1', optimize_use_projections = '1', parallel_replicas_support_projection = '1';

SET read_in_order_two_level_merge_threshold = '1000';

-- { echoOn } --
SET optimize_aggregation_in_order = '0';

SELECT trimLeft(*)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT sum(b)
                FROM pr_t
                GROUP BY a
                ORDER BY a ASC
                LIMIT 5
                OFFSET 500
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%';

SET optimize_aggregation_in_order = '1';

EXPLAIN PIPELINE
SELECT sum(b)
FROM pr_t
GROUP BY a
ORDER BY a ASC
LIMIT 5
OFFSET 500;

SELECT sum(b)
FROM pr_t
GROUP BY a
ORDER BY a ASC
LIMIT 5
OFFSET 500;