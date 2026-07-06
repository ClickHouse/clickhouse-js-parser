-- Tags: long, no-shared-merge-tree
-- no-shared-merge-tree: depend on replication queue/fetches
SET insert_keeper_fault_injection_probability = '0'; -- disable fault injection; part ids are non-deterministic in case of insert retries

DROP TABLE IF EXISTS rmt1;

DROP TABLE IF EXISTS rmt2;

CREATE TABLE rmt1
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02448/{database}/rmt', '1')
ORDER BY tuple()
SETTINGS min_replicated_logs_to_keep = '1', max_replicated_logs_to_keep = '2', max_cleanup_delay_period = '1', cleanup_delay_period = '0', cleanup_delay_period_random_add = '1', cleanup_thread_preferred_points_per_iteration = '0', old_parts_lifetime = '0', max_parts_to_merge_at_once = '4', merge_selecting_sleep_ms = '1000', max_merge_selecting_sleep_ms = '2000';

CREATE TABLE rmt2
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02448/{database}/rmt', '2')
ORDER BY tuple()
SETTINGS min_replicated_logs_to_keep = '1', max_replicated_logs_to_keep = '2', max_cleanup_delay_period = '1', cleanup_delay_period = '0', cleanup_delay_period_random_add = '1', cleanup_thread_preferred_points_per_iteration = '0', old_parts_lifetime = '0', max_parts_to_merge_at_once = '4', merge_selecting_sleep_ms = '1000', max_merge_selecting_sleep_ms = '2000';

-- insert part only on one replica
SYSTEM STOP REPLICATED SENDS rmt1;

INSERT INTO rmt1;

DETACH TABLE rmt1; -- make replica inactive

SYSTEM START REPLICATED SENDS rmt1;

-- trigger log rotation, rmt1 will be lost
INSERT INTO rmt2;

INSERT INTO rmt2;

INSERT INTO rmt2;

INSERT INTO rmt2;

-- check that entry was not removed from the queue (part is not lost)
SET receive_timeout = '5';

SYSTEM SYNC REPLICA rmt2; -- {serverError TIMEOUT_EXCEEDED}

SET receive_timeout = '300';

SELECT
    1,
    arraySort(groupArray(n))
FROM rmt2;

-- rmt1 will mimic rmt2
ATTACH TABLE rmt1;

SYSTEM SYNC REPLICA rmt1;

-- check that no parts are lost
SELECT
    2,
    arraySort(groupArray(n))
FROM rmt1;

SELECT
    3,
    arraySort(groupArray(n))
FROM rmt2;

TRUNCATE TABLE rmt1;

TRUNCATE TABLE rmt2;

-- insert parts only on one replica and merge them
SYSTEM STOP REPLICATED SENDS rmt2;

INSERT INTO rmt2;

OPTIMIZE TABLE rmt2 FINAL;

-- give it a chance to remove source parts
SELECT sleep(2)
FORMAT Null; -- increases probability of reproducing the issue

DETACH TABLE rmt2;

SYSTEM START REPLICATED SENDS rmt2;

-- trigger log rotation, rmt2 will be lost
INSERT INTO rmt1;

INSERT INTO rmt1;

INSERT INTO rmt1;

SELECT
    4,
    arraySort(groupArray(n))
FROM rmt1;

-- rmt1 will mimic rmt2
SYSTEM STOP FETCHES rmt1;

ATTACH TABLE rmt2;

SYSTEM START FETCHES rmt1;

-- check that no parts are lost
SELECT
    5,
    arraySort(groupArray(n))
FROM rmt1;

SELECT
    6,
    arraySort(groupArray(n))
FROM rmt2;

INSERT INTO rmt1;

ALTER TABLE rmt1 UPDATE n = 10 WHERE n = 123 SETTINGS mutations_sync = '1';

-- trigger log rotation, rmt1 will be lost
INSERT INTO rmt2;

INSERT INTO rmt2;

INSERT INTO rmt2;

INSERT INTO rmt2;

SELECT
    7,
    arraySort(groupArray(n))
FROM rmt2;

-- rmt1 will mimic rmt2
SYSTEM STOP FETCHES rmt2;

SYSTEM START FETCHES rmt2;

-- check that no parts are lost
SELECT
    8,
    arraySort(groupArray(n))
FROM rmt1;

SELECT
    9,
    arraySort(groupArray(n))
FROM rmt2;

-- insert parts (all_18_18_0, all_19_19_0) on both replicas (will be deduplicated, but it does not matter)
INSERT INTO rmt1;

INSERT INTO rmt2;

INSERT INTO rmt1;

INSERT INTO rmt2;

-- create a gap in block numbers by dropping part
INSERT INTO rmt2;

ALTER TABLE rmt2 DROP PART 'all_19_19_0'; -- remove 200

INSERT INTO rmt2;

INSERT INTO rmt2;

INSERT INTO rmt2;

-- merge through gap
OPTIMIZE TABLE rmt2;

-- give it a chance to cleanup log
SELECT sleepEachRow(2)
FROM url('http://localhost:8123/?param_tries={1..10}&query=' || encodeURLComponent('select value from system.zookeeper where path=''/test/02448/' || currentDatabase() || '/rmt/replicas/1'' and name=''is_lost'' and value=''0'''), 'LineAsString', 's String')
SETTINGS
    max_threads = '1',
    http_make_head_request = '0'
FORMAT Null;

-- rmt1 should not show the value (200) from dropped part
SELECT throwIf(n = 200)
FROM rmt1
FORMAT Null;

SELECT
    11,
    arraySort(groupArray(n))
FROM rmt2;

SELECT
    12,
    arraySort(groupArray(n))
FROM rmt1;

DROP TABLE rmt1;

DROP TABLE rmt2;