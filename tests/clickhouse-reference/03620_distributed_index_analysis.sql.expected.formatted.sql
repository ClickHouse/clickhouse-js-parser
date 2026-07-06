-- Tags: no-random-merge-tree-settings, no-random-settings
-- - no-random-merge-tree-settings -- may change number of parts
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

SET allow_experimental_parallel_reading_from_replicas = '0';

SET cluster_for_parallel_replicas = '';

SELECT
    groupArraySortedDistinct(10)(_part),
    sum(key)
FROM test_10m
SETTINGS distributed_index_analysis = '1'; -- { serverError CLUSTER_DOESNT_EXIST }

--- Ignore warnings when replica does not respond, and analysis is done on initiator
SET send_logs_level = 'error';

-- { echo }
SELECT
    groupArraySortedDistinct(10)(_part),
    sum(key)
FROM test_10m
SETTINGS distributed_index_analysis = '0';

SELECT
    groupArraySortedDistinct(10)(_part),
    sum(key)
FROM test_10m
SETTINGS
    cluster_for_parallel_replicas = 'parallel_replicas',
    distributed_index_analysis = '1';

-- { echoOff }
SYSTEM FLUSH LOGS query_log;

SELECT format('distributed_index_analysis={}, DistributedIndexAnalysisMicroseconds>0={}, DistributedIndexAnalysisMissingParts={}, DistributedIndexAnalysisScheduledReplicas={}, DistributedIndexAnalysisFailedReplicas>0={}', `Settings`['distributed_index_analysis'], ProfileEvents['DistributedIndexAnalysisMicroseconds'] > 0, ProfileEvents['DistributedIndexAnalysisMissingParts'], ProfileEvents['DistributedIndexAnalysisScheduledReplicas'], ProfileEvents['DistributedIndexAnalysisFailedReplicas'] > 0)
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= yesterday()
    AND type = 'QueryFinish'
    AND query_kind = 'Select'
    AND is_initial_query
    AND has(`Settings`, 'allow_experimental_parallel_reading_from_replicas')
    AND endsWith(log_comment, '-' || currentDatabase())
ORDER BY event_time_microseconds ASC;