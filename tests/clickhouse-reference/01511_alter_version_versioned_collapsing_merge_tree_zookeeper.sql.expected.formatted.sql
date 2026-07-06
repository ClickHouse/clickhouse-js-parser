-- Tags: zookeeper
DROP TABLE IF EXISTS table_with_version_replicated_1;

DROP TABLE IF EXISTS table_with_version_replicated_2;

CREATE TABLE table_with_version_replicated_1
(
    key UInt64,
    value String,
    version UInt8,
    sign Int8
)
ENGINE = ReplicatedVersionedCollapsingMergeTree('/clickhouse/' || currentDatabase() || '/test_01511/{shard}/t', '1_{replica}', sign, version)
ORDER BY key;

CREATE TABLE table_with_version_replicated_2
(
    key UInt64,
    value String,
    version UInt8,
    sign Int8
)
ENGINE = ReplicatedVersionedCollapsingMergeTree('/clickhouse/' || currentDatabase() || '/test_01511/{shard}/t', '2_{replica}', sign, version)
ORDER BY key;

INSERT INTO table_with_version_replicated_1;

INSERT INTO table_with_version_replicated_1;

SELECT *
FROM table_with_version_replicated_1
ORDER BY key ASC;

SHOW CREATE TABLE table_with_version_replicated_1;

ALTER TABLE table_with_version_replicated_1 MODIFY COLUMN version UInt32 SETTINGS replication_alter_partitions_sync = '2';

INSERT INTO table_with_version_replicated_1;

INSERT INTO table_with_version_replicated_1;

SELECT *
FROM table_with_version_replicated_1 FINAL
ORDER BY key ASC;

INSERT INTO table_with_version_replicated_1;

INSERT INTO table_with_version_replicated_1;

SYSTEM SYNC REPLICA table_with_version_replicated_2;

DETACH TABLE table_with_version_replicated_1;

DETACH TABLE table_with_version_replicated_2;

ATTACH TABLE table_with_version_replicated_2;

ATTACH TABLE table_with_version_replicated_1;

SHOW CREATE TABLE table_with_version_replicated_2;

SELECT *
FROM table_with_version_replicated_2 FINAL
ORDER BY key ASC;