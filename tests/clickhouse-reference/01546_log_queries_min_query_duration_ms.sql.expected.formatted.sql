SET log_queries_min_query_duration_ms = '300000';

SET log_query_threads = '1';

SET log_queries = '1';

--
-- fast -- no logging
--
SELECT '01546_log_queries_min_query_duration_ms-fast'
FORMAT Null;

SYSTEM FLUSH LOGS query_log, query_thread_log;

-- No logging, since the query is fast enough.
SELECT count()
FROM `system`.query_log
WHERE query LIKE 'select ''01546_log_queries_min_query_duration_ms-fast%'
    AND current_database = currentDatabase()
    AND event_date >= yesterday();

SELECT count()
FROM `system`.query_thread_log
WHERE query LIKE 'select ''01546_log_queries_min_query_duration_ms-fast%'
    AND current_database = currentDatabase()
    AND event_date >= yesterday();

--
-- slow -- query logged
--
SET log_queries_min_query_duration_ms = '300';

SELECT
    '01546_log_queries_min_query_duration_ms-slow',
    sleep(0.4)
FORMAT Null;

-- With the limit on minimum execution time, "query start" and "exception before start" events are not logged, only query finish.
SELECT count()
FROM `system`.query_log
WHERE query LIKE 'select ''01546_log_queries_min_query_duration_ms-slow%'
    AND current_database = currentDatabase()
    AND event_date >= yesterday();

-- There at least two threads involved in a simple query
-- (one thread just waits another, sigh)
SELECT if(count() = 2, 'OK', 'Fail: ' || toString(count()))
FROM `system`.query_thread_log
WHERE query LIKE 'select ''01546_log_queries_min_query_duration_ms-slow%'
    AND current_database = currentDatabase()
    AND event_date >= yesterday();