DROP TABLE IF EXISTS test_10m;

CREATE TABLE test_10m
(
    key Int,
    value Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS distributed_index_analysis_min_parts_to_activate = '0', distributed_index_analysis_min_indexes_size_to_activate = '0';

INSERT INTO test_10m SELECT
    number,
    number * 100
FROM numbers(1000000.);

SET allow_experimental_parallel_reading_from_replicas = '0';

SET cluster_for_parallel_replicas = 'parallel_replicas';

--- Ignore warnings when replica does not respond, and analysis is done on initiator
SET send_logs_level = 'error';

SELECT sum(key)
FROM test_10m
SETTINGS
    distributed_index_analysis = '1',
    distributed_index_analysis_for_non_shared_merge_tree = '0'
FORMAT Null;

SELECT sum(key)
FROM test_10m
SETTINGS
    distributed_index_analysis = '1',
    distributed_index_analysis_for_non_shared_merge_tree = '1'
FORMAT Null;

SYSTEM FLUSH LOGS query_log;

SELECT format('distributed_index_analysis_for_non_shared_merge_tree={}, DistributedIndexAnalysisMicroseconds>0={}', `Settings`['distributed_index_analysis_for_non_shared_merge_tree'], ProfileEvents['DistributedIndexAnalysisMicroseconds'] > 0)
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= yesterday()
    AND type = 'QueryFinish'
    AND query_kind = 'Select'
    AND is_initial_query
    AND has(`Settings`, 'distributed_index_analysis')
    AND endsWith(log_comment, '-' || currentDatabase())
ORDER BY event_time_microseconds ASC;