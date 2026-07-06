-- Tags: no-fasttest, no-shared-merge-tree, use-rocksdb
-- Tag no-fasttest -- due to EmbeddedRocksDB
-- Tag no-shared-merge-tree -- due to system.replication_queue
DROP TABLE IF EXISTS `null`;

DROP TABLE IF EXISTS dist;

CREATE TABLE `null` AS `system`.one
ENGINE = Null();

CREATE TABLE dist AS `null`
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), 'null', rand());

INSERT INTO dist SETTINGS prefer_localhost_replica = '0';

SELECT
    'system.distribution_queue',
    count()
FROM `system`.distribution_queue
WHERE exists((
        SELECT 1
    ))
    AND database = currentDatabase();

DROP TABLE IF EXISTS rocksdb;

CREATE TABLE rocksdb
(
    key Int
)
ENGINE = EmbeddedRocksDB()
PRIMARY KEY key;

INSERT INTO rocksdb;

SELECT
    'system.rocksdb',
    count() > 0
FROM `system`.rocksdb
WHERE exists((
        SELECT 1
    ))
    AND database = currentDatabase();

SELECT
    'system.databases',
    count()
FROM `system`.databases
WHERE exists((
        SELECT 1
    ))
    AND database = currentDatabase();

DROP TABLE IF EXISTS mt;

CREATE TABLE mt
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key;

ALTER TABLE mt DELETE WHERE 1;

SELECT
    'system.mutations',
    count()
FROM `system`.mutations
WHERE exists((
        SELECT 1
    ))
    AND database = currentDatabase();

DROP TABLE IF EXISTS rep1;

DROP TABLE IF EXISTS rep2;

CREATE TABLE rep1
(
    key Int
)
ENGINE = ReplicatedMergeTree('/{database}/rep', '{table}')
ORDER BY key;

CREATE TABLE rep2
(
    key Int
)
ENGINE = ReplicatedMergeTree('/{database}/rep', '{table}')
ORDER BY key;

SYSTEM STOP FETCHES rep2;

INSERT INTO rep1;

SYSTEM SYNC REPLICA rep2 PULL;

SELECT
    'system.replication_queue',
    count() > 0
FROM `system`.replication_queue
WHERE exists((
        SELECT 1
    ))
    AND database = currentDatabase();