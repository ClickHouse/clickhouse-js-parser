SET log_formatted_queries = '1';

SELECT '02005_log_formatted_queries.sql'
FROM `system`.one;

SYSTEM FLUSH LOGS query_log;

SELECT
    query,
    formatted_query
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query = 'select ''02005_log_formatted_queries.sql'' from system.one;'
    AND event_date >= yesterday()
    AND event_time > now() - toIntervalMinute(5);