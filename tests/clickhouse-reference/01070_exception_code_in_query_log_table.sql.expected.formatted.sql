DROP TABLE IF EXISTS test_table_for_01070_exception_code_in_query_log_table;

SELECT *
FROM test_table_for_01070_exception_code_in_query_log_table; -- { serverError UNKNOWN_TABLE }

CREATE TABLE test_table_for_01070_exception_code_in_query_log_table
(
    value UInt64
)
ENGINE = Memory();

SYSTEM FLUSH LOGS query_log;

SELECT exception_code
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND lower(query) LIKE lower('SELECT * FROM test_table_for_01070_exception_code_in_query_log_table%')
    AND event_date >= yesterday()
    AND event_time > now() - toIntervalMinute(5)
ORDER BY exception_code ASC;