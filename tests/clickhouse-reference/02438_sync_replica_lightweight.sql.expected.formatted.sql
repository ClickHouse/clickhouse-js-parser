-- Tags: no-replicated-database, no-shared-merge-tree
-- Tag no-replicated-database: different number of replicas
-- Tag no-shared-merge-tree: sync replica lightweight by default
-- May affect part names
SET prefer_warmed_unmerged_parts_seconds = '0';

SET ignore_cold_parts_seconds = '0';

CREATE TABLE rmt1
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/{database}/02438/', '1')
ORDER BY tuple()
SETTINGS cache_populated_by_fetch = '0';

CREATE TABLE rmt2
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/{database}/02438/', '2')
ORDER BY tuple()
SETTINGS cache_populated_by_fetch = '0';

SYSTEM STOP REPLICATED SENDS rmt1;

SYSTEM STOP MERGES rmt2;

SET insert_keeper_fault_injection_probability = '0';

INSERT INTO rmt1;

INSERT INTO rmt1;

SYSTEM SYNC REPLICA rmt2 PULL; -- does not wait

SELECT
    type,
    new_part_name
FROM `system`.replication_queue
WHERE database = currentDatabase()
    AND table = 'rmt2'
ORDER BY new_part_name ASC;

SELECT
    1,
    n,
    _part
FROM rmt1
ORDER BY n ASC;

SELECT
    2,
    n,
    _part
FROM rmt2
ORDER BY n ASC;

SET optimize_throw_if_noop = '1';

SYSTEM SYNC REPLICA rmt1 PULL;

OPTIMIZE TABLE rmt1 FINAL;

SYSTEM START REPLICATED SENDS rmt1;

SYSTEM SYNC REPLICA rmt2 LIGHTWEIGHT; -- waits for fetches, not merges

SELECT
    3,
    n,
    _part
FROM rmt1
ORDER BY n ASC;

SELECT
    4,
    n
FROM rmt2
ORDER BY n ASC;

SYSTEM START MERGES rmt2;

SYSTEM SYNC REPLICA rmt2;

INSERT INTO rmt2;

OPTIMIZE TABLE rmt2 FINAL;

SYSTEM SYNC REPLICA rmt1 STRICT;

SELECT
    5,
    n,
    _part
FROM rmt1
ORDER BY n ASC;

SELECT
    6,
    n,
    _part
FROM rmt2
ORDER BY n ASC;

DROP TABLE rmt1;

DROP TABLE rmt2;