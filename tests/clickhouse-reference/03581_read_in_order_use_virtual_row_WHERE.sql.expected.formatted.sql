-- Tags: no-random-merge-tree-settings, no-random-settings
CREATE TABLE tab
(
    x UInt64,
    y UInt64
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO tab SELECT
    number,
    number
FROM numbers(1000000.);

INSERT INTO tab SELECT
    number,
    number
FROM numbers(1000000., 1000000.);

SELECT
    _part,
    min(x),
    max(x)
FROM tab
GROUP BY _part
ORDER BY _part ASC;

SELECT x
FROM tab
WHERE bitAnd(y, 1023) = 0
ORDER BY x ASC
LIMIT 10
SETTINGS
    read_in_order_use_virtual_row = '1',
    log_processors_profiles = '1',
    optimize_move_to_prewhere = '0',
    max_threads = '2';

SYSTEM FLUSH LOGS query_log, processors_profile_log;

WITH (
        SELECT query_id
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
            AND query LIKE 'select x from tab%'
            AND event_date >= today() - 1
        ORDER BY event_time DESC
        LIMIT 1
    ) AS id

SELECT
    replace(name, 'ReadPoolParallelReplicasInOrder', 'ReadPoolInOrder') AS name,
    output_rows
FROM `system`.processors_profile_log
WHERE event_date >= today() - 1
    AND query_id = id
    AND (name LIKE '%MergeTreeSelect%'
    OR name LIKE '%VirtualRowTransform%')
ORDER BY
    name ASC,
    output_rows ASC;