DROP TABLE IF EXISTS table_01323_many_parts;

SET remote_filesystem_read_method = 'read';

SET local_filesystem_read_method = 'pread';

SET load_marks_asynchronously = '0';

SET allow_asynchronous_read_from_io_pool_for_merge_tree = '0';

CREATE TABLE table_01323_many_parts
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY x % 100;

SET max_partitions_per_insert_block = '100';

INSERT INTO table_01323_many_parts SELECT number
FROM numbers(100000);

SET max_threads = '16';

SET log_queries = '1';

SELECT x
FROM table_01323_many_parts
LIMIT 10
FORMAT Null;

SYSTEM FLUSH LOGS query_log;

SELECT peak_threads_usage <= 4
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= today() - 1
    AND query ILIKE '%select x from table_01323_many_parts%'
    AND query NOT LIKE '%system.query_log%'
    AND type = 'QueryFinish'
ORDER BY query_start_time DESC
LIMIT 1;

SELECT x
FROM table_01323_many_parts
ORDER BY x ASC
LIMIT 10
FORMAT Null;

SELECT peak_threads_usage <= 36
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= today() - 1
    AND query ILIKE '%select x from table_01323_many_parts order by x%'
    AND query NOT LIKE '%system.query_log%'
    AND type = 'QueryFinish'
ORDER BY query_start_time DESC
LIMIT 1;