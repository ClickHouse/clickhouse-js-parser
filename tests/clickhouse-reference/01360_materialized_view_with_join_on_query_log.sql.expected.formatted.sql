-- Tags: no-parallel, memory-engine
-- no-parallel: Slows down query_log
DROP TABLE IF EXISTS slow_log;

DROP TABLE IF EXISTS expected_times;

CREATE TABLE expected_times
(
    QUERY_GROUP_ID String,
    max_query_duration_ms UInt64
)
ENGINE = Memory();

INSERT INTO expected_times;

SET log_queries = '1';

SELECT 1;

SYSTEM FLUSH LOGS query_log;

-- NOTE: can be rewritten using log_queries_min_query_duration_ms
CREATE MATERIALIZED VIEW slow_log
ENGINE = Memory()
AS
SELECT *
FROM
    (
        SELECT
            extract(query, '/\\*\\s*QUERY_GROUP_ID:(.*?)\\s*\\*/') AS QUERY_GROUP_ID,
            *
        FROM `system`.query_log
        WHERE type != 1
            AND event_date >= yesterday()
    ) AS ql
INNER JOIN expected_times
    USING (QUERY_GROUP_ID)
WHERE query_duration_ms > max_query_duration_ms;

SELECT 1
WHERE NOT ignore(sleep(0.52)); /* QUERY_GROUP_ID:main_dashboard_top_query */

SET log_queries = '0';

SELECT
    extract(query, '/\\*\\s*QUERY_GROUP_ID:(.*?)\\s*\\*/') AS QUERY_GROUP_ID,
    count()
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND type != 1
    AND event_date >= yesterday()
    AND QUERY_GROUP_ID != ''
GROUP BY QUERY_GROUP_ID
ORDER BY QUERY_GROUP_ID ASC;

SELECT
    QUERY_GROUP_ID,
    count()
FROM slow_log
WHERE current_database = currentDatabase()
GROUP BY QUERY_GROUP_ID
ORDER BY QUERY_GROUP_ID ASC;

DROP TABLE slow_log;

DROP TABLE expected_times;