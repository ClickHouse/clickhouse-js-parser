-- Tags: zookeeper, no-shared-merge-tree
-- no-shared-merge-tree: boring test, nothing new
SET optimize_on_insert = '0';

DROP TABLE IF EXISTS replicated_with_sampling;

CREATE TABLE replicated_with_sampling
(
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00509/replicated_with_sampling', 'r1')
ORDER BY x
SAMPLE BY x;

INSERT INTO replicated_with_sampling;

SELECT sum(x)
FROM replicated_with_sampling SAMPLE 1/2;

DROP TABLE replicated_with_sampling;

DROP TABLE IF EXISTS replacing;

CREATE TABLE replacing
(
    d Date,
    x UInt32,
    s String
)
ENGINE = ReplacingMergeTree()
ORDER BY x
PARTITION BY d;

INSERT INTO replacing;

INSERT INTO replacing;

INSERT INTO replacing;

OPTIMIZE TABLE replacing PARTITION '2017-10-23' FINAL;

SELECT *
FROM replacing;

DROP TABLE replacing;

DROP TABLE IF EXISTS replicated_collapsing;

CREATE TABLE replicated_collapsing
(
    d Date,
    x UInt32,
    sign Int8
)
ENGINE = ReplicatedCollapsingMergeTree('/clickhouse/tables/{database}/test_00509/replicated_collapsing', 'r1', sign)
ORDER BY d
PARTITION BY toYYYYMM(d);

INSERT INTO replicated_collapsing;

INSERT INTO replicated_collapsing;

SYSTEM SYNC REPLICA replicated_collapsing PULL;

OPTIMIZE TABLE replicated_collapsing PARTITION 201710 FINAL;

SELECT *
FROM replicated_collapsing;

DROP TABLE replicated_collapsing;

DROP TABLE IF EXISTS replicated_versioned_collapsing;

CREATE TABLE replicated_versioned_collapsing
(
    d Date,
    x UInt32,
    sign Int8,
    version UInt8
)
ENGINE = ReplicatedVersionedCollapsingMergeTree('/clickhouse/tables/{database}/test_00509/replicated_versioned_collapsing', 'r1', sign, version)
ORDER BY (d, version)
PARTITION BY toYYYYMM(d);

INSERT INTO replicated_versioned_collapsing;

INSERT INTO replicated_versioned_collapsing;

INSERT INTO replicated_versioned_collapsing;

SYSTEM SYNC REPLICA replicated_versioned_collapsing;

OPTIMIZE TABLE replicated_versioned_collapsing PARTITION 201710 FINAL;

SELECT *
FROM replicated_versioned_collapsing;

DROP TABLE replicated_versioned_collapsing;

DROP TABLE IF EXISTS with_settings;

CREATE TABLE with_settings
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00509/with_settings', 'r1')
ORDER BY x
SETTINGS replicated_can_become_leader = '0';

SELECT sleep(1); -- If replicated_can_become_leader were true, this replica would become the leader after 1 second.

SELECT is_leader
FROM `system`.replicas
WHERE database = currentDatabase()
    AND table = 'with_settings';

DROP TABLE with_settings;