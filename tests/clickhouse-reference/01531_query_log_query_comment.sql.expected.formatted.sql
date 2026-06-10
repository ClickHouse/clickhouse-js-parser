SET log_queries = '1';

SET log_queries_min_type = 'QUERY_FINISH';

SET enable_global_with_statement = '0';

SELECT
    /* test=01531, enable_global_with_statement=0 */
    2;

SYSTEM FLUSH LOGS query_log;

SELECT count()
FROM `system`.query_log
WHERE event_date >= yesterday()
    AND query LIKE 'select /* test=01531, enable_global_with_statement=0 */ 2%'
    AND current_database = currentDatabase();

SET enable_global_with_statement = '1';