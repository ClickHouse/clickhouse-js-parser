-- Tags: long, zookeeper, no-replicated-database, no-polymorphic-parts, no-random-merge-tree-settings, no-shared-merge-tree, no-async-insert
-- Tag no-replicated-database: Fails due to additional replicas or shards
-- no-shared-merge-tree: depends on structure in zookeeper of replicated merge tree
-- no-async-insert: Test expects new part for each insert
SET insert_keeper_fault_injection_probability = '0'; -- disable fault injection; part ids are non-deterministic in case of insert retries

DROP TABLE IF EXISTS rmt SYNC;

-- cleanup code will perform extra Exists
-- (so the .reference will not match)
CREATE TABLE rmt
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/01158/{database}/rmt', '1')
ORDER BY n
SETTINGS cleanup_delay_period = '86400', max_cleanup_delay_period = '86400', replicated_can_become_leader = '0';

SYSTEM SYNC REPLICA rmt;

INSERT INTO rmt;

SYSTEM FLUSH LOGS zookeeper_log, query_log;

SELECT
    address,
    type,
    has_watch,
    op_num,
    path,
    is_ephemeral,
    is_sequential,
    version,
    requests_size,
    request_idx,
    error,
    watch_type,
    watch_state,
    path_created,
    stat_version,
    stat_cversion,
    stat_dataLength,
    stat_numChildren
FROM `system`.zookeeper_log
WHERE path LIKE '/test/01158/' || currentDatabase() || '/rmt/log%'
    AND op_num NOT IN (3, 4, 12, 500)
ORDER BY
    xid ASC,
    type ASC,
    request_idx ASC;

WITH now() - toIntervalHour(1) AS cutoff_time,

query_ids AS (
    SELECT query_id
    FROM `system`.query_log
    WHERE current_database = currentDatabase()
        AND event_time >= cutoff_time
)

SELECT
    type,
    has_watch,
    op_num,
    replace(path, toString(serverUUID()), '<uuid>'),
    is_ephemeral,
    is_sequential,
    if(startsWith(path, '/clickhouse/sessions'), 1, version),
    requests_size,
    request_idx,
    error,
    watch_type,
    watch_state,
    path_created,
    stat_version,
    stat_cversion,
    stat_dataLength,
    stat_numChildren
FROM `system`.zookeeper_log
WHERE event_time >= cutoff_time
    AND (session_id, xid) IN (
        SELECT
            session_id,
            xid
        FROM `system`.zookeeper_log
        WHERE event_time >= cutoff_time
            AND path = '/test/01158/' || currentDatabase() || '/rmt/replicas/1/parts/all_0_0_0'
            AND (query_id = ''
            OR query_id IN (query_ids))
    )
ORDER BY
    xid ASC,
    type ASC,
    request_idx ASC;

WITH now() - toIntervalHour(1) AS cutoff_time,

query_ids AS (
    SELECT query_id
    FROM `system`.query_log
    WHERE current_database = currentDatabase()
        AND event_time >= cutoff_time
)

SELECT
    type,
    has_watch,
    op_num,
    path,
    is_ephemeral,
    is_sequential,
    version,
    requests_size,
    request_idx,
    error,
    watch_type,
    watch_state,
    path_created,
    stat_version,
    stat_cversion,
    stat_dataLength,
    stat_numChildren
FROM `system`.zookeeper_log
WHERE event_time >= cutoff_time
    AND (session_id, xid) IN (
        SELECT
            session_id,
            xid
        FROM `system`.zookeeper_log
        WHERE event_time >= cutoff_time
            AND path LIKE '/test/01158/' || currentDatabase() || '/rmt/blocks/%'
            AND op_num NOT IN (1, 12, 500)
            AND (query_id = ''
            OR query_id IN (query_ids))
    )
ORDER BY
    xid ASC,
    type ASC,
    request_idx ASC;

DROP TABLE rmt SYNC;

SYSTEM FLUSH LOGS zookeeper_log;

SELECT count() > 0
FROM `system`.zookeeper_log
WHERE path LIKE '/test/01158/' || currentDatabase() || '/rmt%'
    AND duration_microseconds > 0;

SYSTEM FLUSH LOGS aggregated_zookeeper_log;

SELECT
    sum(errors[0]) > 0,
    sum(average_latency) > 0
FROM `system`.aggregated_zookeeper_log
WHERE parent_path = '/test/01158/' || currentDatabase() || '/rmt'
    AND operation = 'Create';