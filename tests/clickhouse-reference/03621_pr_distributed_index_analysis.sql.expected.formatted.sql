-- Tags: no-replicated-database, long
-- - no-replicated-database - it uses cluster of multiple nodes, while we use different clusters
-- Make sure that distributed index analysis works with parallel replicas
DROP TABLE IF EXISTS test_10m;

CREATE TABLE test_10m
(
    key Int,
    value Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS distributed_index_analysis_min_parts_to_activate = '0', distributed_index_analysis_min_indexes_size_to_activate = '0';

SYSTEM STOP MERGES test_10m;

INSERT INTO test_10m SELECT
    number,
    number * 100
FROM numbers(10000000.);

SET parallel_replicas_for_non_replicated_merge_tree = '1';

SET parallel_replicas_index_analysis_only_on_coordinator = '1';

SET parallel_replicas_local_plan = '1';

--- Ignore warnings when replica does not respond, and analysis is done on initiator
SET send_logs_level = 'error';

-- { echo }
SELECT sum(key)
FROM test_10m
SETTINGS
    allow_experimental_parallel_reading_from_replicas = '0',
    distributed_index_analysis = '1',
    cluster_for_parallel_replicas = 'parallel_replicas';

SELECT sum(key)
FROM test_10m
SETTINGS
    allow_experimental_parallel_reading_from_replicas = '1',
    distributed_index_analysis = '1',
    cluster_for_parallel_replicas = 'parallel_replicas';

SELECT sum(key)
FROM test_10m
SETTINGS
    allow_experimental_parallel_reading_from_replicas = '1',
    distributed_index_analysis = '1',
    cluster_for_parallel_replicas = 'test_cluster_one_shard_two_replicas';

-- { echoOff }
SYSTEM FLUSH LOGS query_log;

SELECT
    anyIf(normalizeQuery(query), is_initial_query) AS q,
    if(
    -- in case of parallel replicas, it is possible that there will be less subqueries then max, but should not exceed it
    any(`Settings`['allow_experimental_parallel_reading_from_replicas']) = '1',
    if(
    any(`Settings`['cluster_for_parallel_replicas']) = 'parallel_replicas',
    -- the max is hosts in parallel_replicas (10) * 2 (one for the query itself and one for mergeTreeAnalyzeIndexes()) - 1 * 2 (for local replica we do not issue a separate query) + 1 (query itself)
    max2(count(), 19)::UInt64,
    -- the max is hosts in test_cluster_one_shard_two_replicas (2) * 2 (one for the query itself and one for mergeTreeAnalyzeIndexes()) - 1 * 2 (for local replica we do not issue a separate query) + 1 (query itself)
    max2(count(), 3)::UInt64
),
    -- in case of distributed index analyss, it is possible that there will be less subqueries then max, due to failures on remote
    if(any(`Settings`['cluster_for_parallel_replicas']) = 'parallel_replicas', max2(count(), 10)::UInt64, max2(count(), 2)::UInt64)
) AS queries_with_subqueries,
    anyIf(ProfileEvents['DistributedIndexAnalysisScheduledReplicas'] > 0, is_initial_query) AS distributed_index_analysis_replicas,
    anyIf(ProfileEvents['ParallelReplicasUsedCount'] > 0, is_initial_query) AS read_with_parallel_replicas
FROM `system`.query_log
WHERE event_date >= yesterday()
    AND type = 'QueryFinish'
    AND query_kind = 'Select'
    AND `Settings`['distributed_index_analysis'] = '1'
    -- SKIP: current_database = currentDatabase() (it will filter out non-initial queries)
    AND endsWith(log_comment, '-' || currentDatabase())
GROUP BY initial_query_id
ORDER BY min(event_time_microseconds) ASC
FORMAT Vertical;