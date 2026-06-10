-- Tags: no-parallel, no-replicated-database
-- Tag no-parallel: due to attaching to system.query_log
-- Tag no-replicated-database: Replicated database will has extra queries
-- Attach MV to system.query_log and check that writing query_log will not fail
SET log_queries = '1';

DROP TABLE IF EXISTS log_proxy_02572;

DROP TABLE IF EXISTS push_to_logs_proxy_mv_02572;

-- create log tables
SYSTEM FLUSH LOGS query_log;

CREATE TABLE log_proxy_02572 AS `system`.query_log
ENGINE = Distributed('test_shard_localhost', currentDatabase(), 'receiver_02572');

CREATE MATERIALIZED VIEW push_to_logs_proxy_mv_02572
TO log_proxy_02572
AS
SELECT *
FROM `system`.query_log;

SELECT 1
FORMAT Null;

DROP TABLE log_proxy_02572;

DROP TABLE push_to_logs_proxy_mv_02572;

SET log_queries = '0';

-- lower() to pass through clickhouse-test "exception" check
SELECT
    replaceAll(query, '\n', '\\n'),
    lower(type::String),
    errorCodeToName(exception_code)
FROM `system`.query_log
WHERE current_database = currentDatabase()
ORDER BY event_time_microseconds ASC
FORMAT CSV;