SET prefer_localhost_replica = '1';

DROP TABLE IF EXISTS data_02572;

DROP TABLE IF EXISTS proxy_02572;

DROP TABLE IF EXISTS push_to_proxy_mv_02572;

DROP TABLE IF EXISTS receiver_02572;

CREATE TABLE data_02572
(
    key Int
)
ENGINE = Memory();

CREATE TABLE proxy_02572
(
    key Int
)
ENGINE = Distributed('test_shard_localhost', currentDatabase(), 'receiver_02572');

-- ensure that insert fails
INSERT INTO proxy_02572; -- { serverError UNKNOWN_TABLE }

-- proxy data with MV
CREATE MATERIALIZED VIEW push_to_proxy_mv_02572
TO proxy_02572
AS
SELECT *
FROM data_02572;

-- { echoOn }
SELECT *
FROM data_02572
ORDER BY key ASC;

INSERT INTO data_02572 SETTINGS materialized_views_ignore_errors = '1';

-- check system.query_views_log
SYSTEM FLUSH LOGS query_views_log;

-- lower(status) to pass through clickhouse-test "exception" check
SELECT
    lower(status::String),
    errorCodeToName(exception_code)
FROM `system`.query_views_log
WHERE view_name = concatWithSeparator('.', currentDatabase(), 'push_to_proxy_mv_02572')
    AND view_target = concatWithSeparator('.', currentDatabase(), 'proxy_02572')
ORDER BY
    event_date ASC,
    event_time ASC;

-- materialized_views_ignore_errors=0
INSERT INTO data_02572; -- { serverError UNKNOWN_TABLE }

CREATE TABLE receiver_02572 AS data_02572;

INSERT INTO data_02572;

SELECT *
FROM receiver_02572
ORDER BY key ASC;