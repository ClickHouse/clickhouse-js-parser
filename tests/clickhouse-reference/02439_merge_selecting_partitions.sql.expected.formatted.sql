-- Tags: no-shared-merge-tree
-- Predicate works in a different way
DROP TABLE IF EXISTS rmt;

CREATE TABLE rmt
(
    n int,
    m int
)
ENGINE = ReplicatedMergeTree('/test/02439/{shard}/{database}', '{replica}')
ORDER BY n
PARTITION BY n;

INSERT INTO rmt SELECT
    number,
    number
FROM numbers(50);

INSERT INTO rmt;

INSERT INTO rmt;

INSERT INTO rmt;

INSERT INTO rmt;

INSERT INTO rmt;

INSERT INTO rmt;

INSERT INTO rmt;

INSERT INTO rmt;

-- there's nothing to merge in all partitions but '1'
OPTIMIZE TABLE rmt PARTITION tuple(123);

SET optimize_throw_if_noop = '1';

SELECT sleepEachRow(3) AS higher_probability_of_reproducing_the_issue
FORMAT Null;

SYSTEM FLUSH LOGS zookeeper_log, query_log;

-- it should not list unneeded partitions where we cannot merge anything
SELECT *
FROM `system`.zookeeper_log
WHERE path LIKE '/test/02439/' || getMacro('shard') || '/' || currentDatabase() || '/block_numbers/%'
    AND op_num IN ('List', 'SimpleList', 'FilteredList')
    AND path NOT LIKE '%/block_numbers/1'
    AND path NOT LIKE '%/block_numbers/123'
    AND event_time >= now() - toIntervalMinute(1)
    -- avoid race with tests like 02311_system_zookeeper_insert
    AND (query_id IS NULL
    OR query_id = ''
    OR query_id IN (
        SELECT query_id
        FROM `system`.query_log
        WHERE event_time >= now() - toIntervalMinute(1)
            AND current_database = currentDatabase()
    ));

DROP TABLE rmt;