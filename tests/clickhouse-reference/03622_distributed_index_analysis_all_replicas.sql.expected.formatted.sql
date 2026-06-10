-- Tags: long, no-parallel
-- Generate many parts (partitions) to ensure that all replicas will be chosen for distributed index analysis
-- even failed replica (that is included into parallel_replicas cluster), and ensure that the SELECT wont fail (parts should be analyzed locally).
DROP TABLE IF EXISTS test_10m;

CREATE TABLE test_10m
(
    key Int,
    value Int
)
ENGINE = MergeTree()
ORDER BY key
PARTITION BY key % 200
SETTINGS distributed_index_analysis_min_parts_to_activate = '0', distributed_index_analysis_min_indexes_size_to_activate = '0';

SYSTEM STOP MERGES test_10m;

INSERT INTO test_10m SELECT
    number,
    number * 100
FROM numbers(1000000.)
SETTINGS
    max_partitions_per_insert_block = '200',
    max_block_size = 1000000.;

SET allow_experimental_parallel_reading_from_replicas = '0';

SET parallel_replicas_for_non_replicated_merge_tree = '1';

SET parallel_replicas_index_analysis_only_on_coordinator = '1';

SET parallel_replicas_local_plan = '1';

SET distributed_index_analysis = '1';

SET max_parallel_replicas = '100';

SET cluster_for_parallel_replicas = 'parallel_replicas';

--- Ignore warnings when replica does not respond, and analysis is done on initiator
SET send_logs_level = 'error';

-- { echo }
SELECT sum(key)
FROM test_10m;

SELECT sum(key)
FROM test_10m
WHERE key = 1;

-- { echoOff }
SYSTEM FLUSH LOGS query_log;

SELECT
    normalizeQuery(query) AS q,
    ProfileEvents['DistributedIndexAnalysisMicroseconds'] > 0 AS not_blazingly_fast,
    ProfileEvents['DistributedIndexAnalysisMissingParts'] AS missing_parts,
    ProfileEvents['DistributedIndexAnalysisScheduledReplicas'] AS replicas,
    ProfileEvents['DistributedIndexAnalysisFailedReplicas'] > 0 AS failed_replicas
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= yesterday()
    AND type != 'QueryStart'
    AND query_kind = 'Select'
    AND is_initial_query
    AND `Settings`['distributed_index_analysis'] = '1'
    AND endsWith(log_comment, '-' || currentDatabase())
ORDER BY event_time_microseconds ASC
FORMAT Vertical;