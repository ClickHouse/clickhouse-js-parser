SET enable_analyzer = '1';

WITH (
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a1,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a2,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a3,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a4,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a5

SELECT
    '02177_CTE_GLOBAL_ON',
    a1,
    a2,
    a3,
    a4,
    a5
FROM `system`.numbers
LIMIT 100
FORMAT Null
SETTINGS enable_global_with_statement = '1';

WITH (
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a1,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a2,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a3,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a4,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a5

SELECT
    '02177_CTE_GLOBAL_OFF',
    a1,
    a2,
    a3,
    a4,
    a5
FROM `system`.numbers
LIMIT 100
FORMAT Null
SETTINGS enable_global_with_statement = '0';

WITH (
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a1,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a2,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a3,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a4,

(
        SELECT sleep(0.0001)
        FROM `system`.one
    ) AS a5

SELECT
    '02177_CTE_NEW_ANALYZER',
    a1,
    a2,
    a3,
    a4,
    a5
FROM `system`.numbers
LIMIT 100
FORMAT Null
SETTINGS enable_analyzer = '1';

SYSTEM FLUSH LOGS query_log;

SELECT
    '02177_CTE_GLOBAL_ON',
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds,
    ProfileEvents['ScalarSubqueriesGlobalCacheHit'] AS scalar_cache_global_hit,
    ProfileEvents['ScalarSubqueriesLocalCacheHit'] AS scalar_cache_local_hit,
    ProfileEvents['ScalarSubqueriesCacheMiss'] AS scalar_cache_miss
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND type = 'QueryFinish'
    AND query LIKE '%SELECT ''02177_CTE_GLOBAL_ON%'
    AND event_date >= yesterday()
    AND event_time > now() - toIntervalMinute(10);

SELECT
    '02177_CTE_GLOBAL_OFF',
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds,
    ProfileEvents['ScalarSubqueriesGlobalCacheHit'] AS scalar_cache_global_hit,
    ProfileEvents['ScalarSubqueriesLocalCacheHit'] AS scalar_cache_local_hit,
    ProfileEvents['ScalarSubqueriesCacheMiss'] AS scalar_cache_miss
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND type = 'QueryFinish'
    AND query LIKE '%02177_CTE_GLOBAL_OFF%'
    AND event_date >= yesterday()
    AND event_time > now() - toIntervalMinute(10);

SELECT
    '02177_CTE_NEW_ANALYZER',
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds,
    ProfileEvents['ScalarSubqueriesGlobalCacheHit'] AS scalar_cache_global_hit,
    ProfileEvents['ScalarSubqueriesLocalCacheHit'] AS scalar_cache_local_hit,
    ProfileEvents['ScalarSubqueriesCacheMiss'] AS scalar_cache_miss
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND type = 'QueryFinish'
    AND query LIKE '%02177_CTE_NEW_ANALYZER%'
    AND event_date >= yesterday()
    AND event_time > now() - toIntervalMinute(10);