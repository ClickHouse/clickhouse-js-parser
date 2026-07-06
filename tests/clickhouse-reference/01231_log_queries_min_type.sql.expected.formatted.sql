SET log_queries = '1';

SYSTEM FLUSH LOGS query_log;

SELECT count()
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query LIKE 'select ''01231_log_queries_min_type/QUERY_START%'
    AND event_date >= yesterday();

SET log_queries_min_type = 'EXCEPTION_BEFORE_START';

SELECT count()
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query LIKE 'select ''01231_log_queries_min_type/EXCEPTION_BEFORE_START%'
    AND event_date >= yesterday();

SET max_rows_to_read = '100K';

SET log_queries_min_type = 'EXCEPTION_WHILE_PROCESSING';

SELECT
    '01231_log_queries_min_type/EXCEPTION_WHILE_PROCESSING',
    max(number)
FROM `system`.numbers
LIMIT 1000000.; -- { serverError TOO_MANY_ROWS }

SET max_rows_to_read = '0';

SELECT count()
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query LIKE 'select ''01231_log_queries_min_type/EXCEPTION_WHILE_PROCESSING%'
    AND event_date >= yesterday()
    AND type = 'ExceptionWhileProcessing';

SELECT
    '01231_log_queries_min_type w/ Settings/EXCEPTION_WHILE_PROCESSING',
    max(number)
FROM `system`.numbers
LIMIT 1000000.; -- { serverError TOO_MANY_ROWS }

SELECT count()
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query LIKE 'select ''01231_log_queries_min_type w/ Settings/EXCEPTION_WHILE_PROCESSING%'
    AND query NOT LIKE '%system.query_log%'
    AND event_date >= yesterday()
    AND type = 'ExceptionWhileProcessing'
    AND `Settings`['max_rows_to_read'] != '';