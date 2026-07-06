SET log_queries = '1';

SELECT count() > 0
FROM `system`.`settings`;

SYSTEM FLUSH LOGS query_log;

SELECT
    result_rows,
    result_bytes >= 8
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= today() - 1
    AND lower(query) LIKE '%select count() > 0 from system.settings%'
    AND type = 'QueryFinish'
ORDER BY query_start_time DESC
LIMIT 1;