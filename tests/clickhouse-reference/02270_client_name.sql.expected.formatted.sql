SELECT 1
SETTINGS
    log_queries = '1',
    log_queries_min_type = 'QUERY_FINISH'
FORMAT Null;

SYSTEM FLUSH LOGS query_log;

SELECT client_name
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query LIKE 'select 1%'
FORMAT CSV;