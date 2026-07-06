SET log_queries = '1';

SYSTEM FLUSH LOGS query_log;

-- assumes that the query_start_time field is already accurate.
WITH (
    (
        SELECT query_start_time_microseconds
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
            AND query LIKE 'SELECT ''01461_query%'
            AND event_date >= yesterday()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS time_with_microseconds,
    (
        SELECT query_start_time
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
            AND query LIKE 'SELECT ''01461_query%'
            AND event_date >= yesterday()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS t)

SELECT if(dateDiff('second', toDateTime(time_with_microseconds), toDateTime(t)) = 0, 'ok', 'fail'); --

SET log_query_threads = '1';

SYSTEM FLUSH LOGS query_thread_log;

-- assumes that the query_start_time field is already accurate.
WITH (
    (
        SELECT query_start_time_microseconds
        FROM `system`.query_thread_log
        WHERE current_database = currentDatabase()
            AND query LIKE 'SELECT ''01461_query%'
            AND event_date >= yesterday()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS time_with_microseconds,
    (
        SELECT query_start_time
        FROM `system`.query_thread_log
        WHERE current_database = currentDatabase()
            AND query LIKE 'SELECT ''01461_query%'
            AND event_date >= yesterday()
        ORDER BY query_start_time DESC
        LIMIT 1
    ) AS t)

SELECT if(dateDiff('second', toDateTime(time_with_microseconds), toDateTime(t)) = 0, 'ok', 'fail'); --