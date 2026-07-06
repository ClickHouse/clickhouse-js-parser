DROP TABLE IF EXISTS test_1m;

-- -min_bytes_for_wide_part -- wide parts are different (they respect index_granularity completely, unlike compact parts) -- FIXME
-- -merge_selector_base = 1000 -- disable merges
-- -index_granularity* -- test relies on number of granulas
CREATE TABLE test_1m
(
    key Int,
    value Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS merge_selector_base = '1000', index_granularity = '8192', min_bytes_for_wide_part = 1000000000., index_granularity_bytes = 10000000., distributed_index_analysis_min_parts_to_activate = '0', distributed_index_analysis_min_indexes_size_to_activate = '0';

SYSTEM STOP MERGES test_1m;

INSERT INTO test_1m SELECT
    number,
    number * 100
FROM numbers(1000000.)
SETTINGS
    max_block_size = '100000',
    min_insert_block_size_rows = '100000',
    max_insert_threads = '1';

SELECT
    count(),
    sum(marks)
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'test_1m'
    AND active;

SET cluster_for_parallel_replicas = 'parallel_replicas_unavailable_first';

-- Ignore "Cannot analyze parts on {} replica"
SET send_logs_level = 'error';

-- make sure that local replica is not included
SET max_parallel_replicas = '4';

SET use_query_condition_cache = '0';

-- { echo }
SELECT count()
FROM test_1m
WHERE key > 10000
SETTINGS distributed_index_analysis = '0';

SELECT count()
FROM test_1m
WHERE key > 10000
SETTINGS distributed_index_analysis = '1';