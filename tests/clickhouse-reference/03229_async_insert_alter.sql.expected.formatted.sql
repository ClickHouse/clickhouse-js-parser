-- Tags: no-async-insert
SET wait_for_async_insert = '0';

SET async_insert_busy_timeout_max_ms = '300000';

SET async_insert_busy_timeout_min_ms = '300000';

SET async_insert_use_adaptive_busy_timeout = '0';

DROP TABLE IF EXISTS t_async_insert_alter;

CREATE TABLE t_async_insert_alter
(
    id Int64,
    v1 Int64
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS async_insert = '1';

-- ADD COLUMN
INSERT INTO t_async_insert_alter;

ALTER TABLE t_async_insert_alter ADD COLUMN value2 Int64;

SYSTEM FLUSH ASYNC INSERT QUEUE t_async_insert_alter;

SELECT *
FROM t_async_insert_alter
ORDER BY id ASC;

-- MODIFY COLUMN
INSERT INTO t_async_insert_alter;

ALTER TABLE t_async_insert_alter MODIFY COLUMN value2 String;

-- DROP COLUMN
INSERT INTO t_async_insert_alter;

ALTER TABLE t_async_insert_alter DROP COLUMN value2;

SYSTEM FLUSH LOGS asynchronous_insert_log;

SELECT
    query,
    data_kind,
    status
FROM `system`.asynchronous_insert_log
WHERE database = currentDatabase()
    AND table = 't_async_insert_alter'
ORDER BY event_time_microseconds ASC;

DROP TABLE t_async_insert_alter;