SET log_queries = '1';

SET log_profile_events = true;

CREATE TABLE src
ENGINE = MergeTree()
ORDER BY id AS
SELECT
    number AS id,
    toInt32(1) AS value
FROM numbers(1);

CREATE TABLE dst
(
    id UInt64,
    delta Int64
)
ENGINE = MergeTree()
ORDER BY id;

-- First we try with default values (https://github.com/ClickHouse/ClickHouse/issues/9587)
SET use_index_for_in_with_subqueries = '1';

CREATE MATERIALIZED VIEW src2dst_true
TO dst
AS
SELECT
    id,
    src.value - deltas_sum AS delta
FROM
    src
LEFT JOIN (
        SELECT
            id,
            sum(delta) AS deltas_sum
        FROM dst
        WHERE id IN (
                SELECT id
                FROM src
                WHERE NOT sleepEachRow(0.001)
            )
        GROUP BY id
    ) AS _a
    USING (id);

-- Inserting 2 numbers should require 2 calls to sleep
INSERT INTO src SELECT
    number + 100 AS id,
    1
FROM numbers(2);

-- Describe should not need to call sleep
DESCRIBE TABLE (SELECT
    '1947 #3 QUERY - TRUE',
    id,
    src.value - deltas_sum AS delta
FROM
    src
LEFT JOIN (
        SELECT
            id,
            sum(delta) AS deltas_sum
        FROM dst
        WHERE id IN (
                SELECT id
                FROM src
                WHERE NOT sleepEachRow(0.001)
            )
        GROUP BY id
    ) AS _a
    USING (id)) FORMAT Null;

SYSTEM FLUSH LOGS query_log;

SELECT
    '1947 #1 CHECK - TRUE' AS test,
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds
FROM `system`.query_log
WHERE query LIKE '%CREATE MATERIALIZED VIEW src2dst_true%'
    AND type > 1
    AND current_database = currentDatabase()
    AND event_date >= yesterday()
FORMAT JSONEachRow;

SELECT
    '1947 #2 CHECK - TRUE' AS test,
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds
FROM `system`.query_log
WHERE query LIKE '%INSERT into src SELECT number + 100 as id, 1 FROM numbers(2)%'
    AND type > 1
    AND current_database = currentDatabase()
    AND event_date >= yesterday()
FORMAT JSONEachRow;

SELECT
    '1947 #3 CHECK - TRUE' AS test,
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds
FROM `system`.query_log
WHERE query LIKE '%DESCRIBE ( SELECT ''1947 #3 QUERY - TRUE'',%'
    AND type > 1
    AND current_database = currentDatabase()
    AND event_date >= yesterday()
FORMAT JSONEachRow;

DROP TABLE src2dst_true;

-- Retry the same but using use_index_for_in_with_subqueries = 0
SET use_index_for_in_with_subqueries = '0';

CREATE MATERIALIZED VIEW src2dst_false
TO dst
AS
SELECT
    id,
    src.value - deltas_sum AS delta
FROM
    src
LEFT JOIN (
        SELECT
            id,
            sum(delta) AS deltas_sum
        FROM dst
        WHERE id IN (
                SELECT id
                FROM src
                WHERE NOT sleepEachRow(0.001)
            )
        GROUP BY id
    ) AS _a
    USING (id);

-- Inserting 2 numbers should require 2 calls to sleep
INSERT INTO src SELECT
    number + 200 AS id,
    1
FROM numbers(2);

-- Describe should not need to call sleep
DESCRIBE TABLE (SELECT
    '1947 #3 QUERY - FALSE',
    id,
    src.value - deltas_sum AS delta
FROM
    src
LEFT JOIN (
        SELECT
            id,
            sum(delta) AS deltas_sum
        FROM dst
        WHERE id IN (
                SELECT id
                FROM src
                WHERE NOT sleepEachRow(0.001)
            )
        GROUP BY id
    ) AS _a
    USING (id)) FORMAT Null;

SELECT
    '1947 #1 CHECK - FALSE' AS test,
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds
FROM `system`.query_log
WHERE query LIKE '%CREATE MATERIALIZED VIEW src2dst_false%'
    AND type > 1
    AND current_database = currentDatabase()
    AND event_date >= yesterday()
FORMAT JSONEachRow;

SELECT
    '1947 #2 CHECK - FALSE' AS test,
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds
FROM `system`.query_log
WHERE query LIKE '%INSERT into src SELECT number + 200 as id, 1 FROM numbers(2)%'
    AND type > 1
    AND current_database = currentDatabase()
    AND event_date >= yesterday()
FORMAT JSONEachRow;

SELECT
    '1947 #3 CHECK - FALSE' AS test,
    ProfileEvents['SleepFunctionCalls'] AS sleep_calls,
    ProfileEvents['SleepFunctionMicroseconds'] AS sleep_microseconds
FROM `system`.query_log
WHERE query LIKE '%DESCRIBE ( SELECT ''1947 #3 QUERY - FALSE'',%'
    AND type > 1
    AND current_database = currentDatabase()
    AND event_date >= yesterday()
FORMAT JSONEachRow;

DROP TABLE src2dst_false;

DROP TABLE src;

DROP TABLE dst;