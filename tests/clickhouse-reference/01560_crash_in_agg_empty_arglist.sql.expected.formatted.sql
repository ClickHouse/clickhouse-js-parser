-- make sure the system.query_log table is created
SELECT 1;

SYSTEM FLUSH LOGS query_log;

SELECT
    any() AS t,
    substring(query, 1, 70) AS query,
    avg(memory_usage) AS usage,
    count() AS count
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND event_date >= toDate(1604295323)
    AND event_time >= toDateTime(1604295323)
    AND type IN (1, 2, 3, 4)
    AND initial_user IN ('')
    AND ('all' = 'all'
    OR positionCaseInsensitive(query, 'all') = 1)
GROUP BY query
ORDER BY usage DESC
LIMIT 5; -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }