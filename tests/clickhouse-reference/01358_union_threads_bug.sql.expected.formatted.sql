-- Tags: no-parallel, no-fasttest
-- no-parallel: it checks the number of threads, which can be lowered in presence of other queries
SET log_queries = '1';

SET max_threads = '16';

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(1000000)
        ORDER BY number DESC
        LIMIT 100
        UNION ALL
        SELECT number
        FROM numbers_mt(1000000)
        ORDER BY number DESC
        LIMIT 100
        UNION ALL
        SELECT number
        FROM numbers_mt(1000000)
        ORDER BY number DESC
        LIMIT 100
    );

SYSTEM FLUSH LOGS query_log;

SELECT length(thread_ids) >= 1
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= today() - 1
    AND query LIKE '%SELECT count() FROM (SELECT number FROM numbers_mt(1000000) ORDER BY number DESC LIMIT 100 UNION ALL SELECT number FROM numbers_mt(1000000) ORDER BY number DESC LIMIT 100 UNION ALL SELECT number FROM numbers_mt(1000000) ORDER BY number DESC LIMIT 100)%'
    AND type = 'QueryFinish'
ORDER BY query_start_time DESC
LIMIT 1;