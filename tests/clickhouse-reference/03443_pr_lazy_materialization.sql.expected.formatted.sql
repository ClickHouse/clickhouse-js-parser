DROP TABLE IF EXISTS pr_tt;

CREATE TABLE pr_tt
(
    k UInt64,
    v String,
    blob String
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '100';

INSERT INTO pr_tt SELECT
    number,
    toString(number),
    repeat('blob_', number % 10)
FROM numbers(1000000);

-- make sure the optimization is enabled
SET enable_analyzer = '1', query_plan_optimize_lazy_materialization = true, query_plan_max_limit_for_lazy_materialization = '10';

SET enable_parallel_replicas = '1', cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost', parallel_replicas_for_non_replicated_merge_tree = '1';

SELECT trimLeft(`explain`) AS s
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT
                    v,
                    blob
                FROM pr_tt
                ORDER BY k ASC
                LIMIT 10
                SETTINGS parallel_replicas_local_plan = '1'
            ))
    )
WHERE s ILIKE 'LazilyRead%';

SELECT
    v,
    blob
FROM pr_tt
ORDER BY k ASC
LIMIT 10;

DROP TABLE pr_tt;