-- Tags: no-parallel, no-fasttest
-- no-parallel: it checks the number of threads, which can be lowered in presence of other queries
SET log_queries = '1';

SET max_threads = '16';

SET prefer_localhost_replica = '1';

SELECT sum(number)
FROM remote('127.0.0.{1|2}', numbers_mt(1000000))
GROUP BY number % 2
ORDER BY number % 2 ASC;

SYSTEM FLUSH LOGS query_log;

SELECT length(thread_ids) >= 1
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= today() - 1
    AND lower(query) LIKE '%select sum(number) from remote(_127.0.0.{1|2}_, numbers_mt(1000000)) group by number %'
    AND type = 'QueryFinish'
ORDER BY query_start_time DESC
LIMIT 1;