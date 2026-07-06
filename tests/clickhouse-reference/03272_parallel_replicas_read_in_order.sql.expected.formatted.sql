SET log_queries = '1';

SET optimize_read_in_order = '1';

DROP TABLE IF EXISTS read_in_order_with_parallel_replicas;

CREATE TABLE read_in_order_with_parallel_replicas
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '1';

SET max_execution_time = '300';

INSERT INTO read_in_order_with_parallel_replicas SELECT number
FROM `system`.numbers
LIMIT 100000;

SELECT *
FROM read_in_order_with_parallel_replicas
ORDER BY id DESC
LIMIT 1;

SELECT *
FROM read_in_order_with_parallel_replicas
ORDER BY id ASC
LIMIT 1;

SET enable_analyzer = '1', enable_parallel_replicas = '2', max_parallel_replicas = '2', cluster_for_parallel_replicas = 'parallel_replicas', parallel_replicas_for_non_replicated_merge_tree = '1';

SELECT *
FROM read_in_order_with_parallel_replicas
ORDER BY id DESC
LIMIT 1
SETTINGS
    max_threads = '1',
    log_comment = 'test read in order desc with parallel replicas';

SELECT *
FROM read_in_order_with_parallel_replicas
ORDER BY id ASC
LIMIT 1
SETTINGS
    max_threads = '1',
    log_comment = 'test read in order asc with parallel replicas';

-- Check we don't read more mark in parallel replicas
SYSTEM FLUSH LOGS query_log;

SET parallel_replicas_for_non_replicated_merge_tree = '0';

SELECT count(1)
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND log_comment = 'test read in order desc with parallel replicas'
    AND read_rows > 2;

SELECT count(1)
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND log_comment = 'test read in order asc with parallel replicas'
    AND read_rows > 2;

DROP TABLE read_in_order_with_parallel_replicas;