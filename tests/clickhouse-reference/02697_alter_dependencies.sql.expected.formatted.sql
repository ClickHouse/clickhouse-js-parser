CREATE TABLE mv_source
(
    a Int64,
    insert_time DateTime
)
ENGINE = MergeTree()
ORDER BY insert_time;

CREATE TABLE mv_target
(
    a Int64,
    insert_time DateTime
)
ENGINE = MergeTree()
ORDER BY insert_time;

CREATE MATERIALIZED VIEW source_to_target
TO mv_target
AS
SELECT *
FROM mv_source
WHERE a NOT IN (
        SELECT sleepEachRow(0.1)
        FROM numbers(50)
    );

ALTER TABLE mv_source MODIFY TTL insert_time + toIntervalDay(1);

SYSTEM FLUSH LOGS query_log;

-- This is a fancy way to check that the MV hasn't been called (no functions executed by ALTER)
SELECT
    ProfileEvents['FunctionExecute'],
    ProfileEvents['TableFunctionExecute']
FROM `system`.query_log
WHERE type = 'QueryFinish'
    AND query LIKE '%ALTER TABLE mv_source%'
    AND current_database = currentDatabase()
    AND event_time > now() - toIntervalMinute(10);