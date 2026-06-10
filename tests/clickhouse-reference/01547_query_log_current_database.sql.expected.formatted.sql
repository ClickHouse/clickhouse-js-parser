--
-- This is a cleaner approach for writing a test that relies on system.query_log/query_thread_log.
--
-- It uses current database, and since clickhouse-test will generate random for
-- each run you can run the test multiple times without worrying about
-- overlaps.
--
-- There is still event_date/event_time filter for better performance
-- (even though this is not relevant for runs on CI)
--
SET log_query_threads = '1';

SET log_queries_min_type = 'QUERY_FINISH';

SET log_queries = '1';

SELECT '01547_query_log_current_database'
FROM `system`.one
FORMAT Null;

SET log_queries = '0';

SET log_query_threads = '0';

SYSTEM FLUSH LOGS query_log, query_thread_log;

SELECT count()
FROM `system`.query_log
WHERE query LIKE 'select ''01547_query_log_current_database%'
    AND current_database = currentDatabase()
    AND event_date >= yesterday();

-- at least two threads for processing
-- (but one just waits for another, sigh)
SELECT count() = 2
FROM `system`.query_thread_log
WHERE query LIKE 'select ''01547\\_query\\_log\\_current\\_database%'
    AND current_database = currentDatabase()
    AND event_date >= yesterday();