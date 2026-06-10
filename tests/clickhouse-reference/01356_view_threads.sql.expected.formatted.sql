-- Tags: no-parallel, no-fasttest
-- no-parallel: it checks the number of threads, which can be lowered in presence of other queries
DROP TABLE IF EXISTS table_01356_view_threads;

CREATE VIEW table_01356_view_threads
AS
SELECT
    number % 10 AS g,
    sum(number) AS s
FROM numbers_mt(1000000)
GROUP BY g;

SET log_queries = '1';

SET max_threads = '16';

SELECT
    g % 2 AS gg,
    sum(s)
FROM table_01356_view_threads
GROUP BY gg
ORDER BY gg ASC;

SYSTEM FLUSH LOGS query_log;

SELECT length(thread_ids) >= 1
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= today() - 1
    AND lower(query) LIKE '%select g % 2 as gg, sum(s) from table_01356_view_threads group by gg order by gg%'
    AND type = 'QueryFinish'
ORDER BY query_start_time DESC
LIMIT 1;