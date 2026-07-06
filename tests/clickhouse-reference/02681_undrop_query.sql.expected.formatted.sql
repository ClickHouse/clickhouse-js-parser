-- Tags: no-ordinary-database, no-replicated-database, distributed, zookeeper
SET database_atomic_wait_for_drop_and_detach_synchronously = '0';

DROP TABLE IF EXISTS `02681_undrop_mergetree` SYNC;

CREATE TABLE `02681_undrop_mergetree`
(
    id Int32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO `02681_undrop_mergetree`;

DROP TABLE `02681_undrop_mergetree`;

SELECT table
FROM `system`.dropped_tables
WHERE table = '02681_undrop_mergetree'
LIMIT 1;

UNDROP TABLE `02681_undrop_mergetree`;

SELECT *
FROM `02681_undrop_mergetree`
ORDER BY id ASC;

DROP TABLE `02681_undrop_mergetree` SYNC;

DROP TABLE IF EXISTS `02681_undrop_detach` SYNC;

CREATE TABLE `02681_undrop_detach`
(
    id Int32,
    num Int32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO `02681_undrop_detach`;

DETACH TABLE `02681_undrop_detach` SYNC;

UNDROP TABLE `02681_undrop_detach`; -- { serverError TABLE_ALREADY_EXISTS }

ATTACH TABLE `02681_undrop_detach`;

ALTER TABLE `02681_undrop_detach` UPDATE num = 2 WHERE id = 1;

SELECT command
FROM `system`.mutations
WHERE table = '02681_undrop_detach'
    AND database = currentDatabase()
LIMIT 1;

DROP TABLE `02681_undrop_detach` SYNC;

DROP TABLE IF EXISTS `02681_undrop_uuid_on_cluster` ON CLUSTER test_shard_localhost SYNC FORMAT Null;

CREATE TABLE `02681_undrop_uuid_on_cluster` ON CLUSTER test_shard_localhost
(
    id Int32
)
ENGINE = MergeTree()
ORDER BY id
FORMAT Null;

INSERT INTO `02681_undrop_uuid_on_cluster`;

DROP TABLE `02681_undrop_uuid_on_cluster` ON CLUSTER test_shard_localhost FORMAT Null;

SELECT table
FROM `system`.dropped_tables
WHERE table = '02681_undrop_uuid_on_cluster'
LIMIT 1;

UNDROP TABLE `02681_undrop_uuid_on_cluster` ON CLUSTER test_shard_localhost FORMAT Null;

SELECT *
FROM `02681_undrop_uuid_on_cluster`
ORDER BY id ASC;

DROP TABLE `02681_undrop_uuid_on_cluster` SYNC;

DROP TABLE IF EXISTS `02681_undrop_no_uuid_on_cluster` ON CLUSTER test_shard_localhost SYNC FORMAT Null;

CREATE TABLE `02681_undrop_no_uuid_on_cluster` ON CLUSTER test_shard_localhost
(
    id Int32
)
ENGINE = MergeTree()
ORDER BY id
FORMAT Null;

INSERT INTO `02681_undrop_no_uuid_on_cluster`;

DROP TABLE `02681_undrop_no_uuid_on_cluster` ON CLUSTER test_shard_localhost FORMAT Null;

SELECT table
FROM `system`.dropped_tables
WHERE table = '02681_undrop_no_uuid_on_cluster'
LIMIT 1;

UNDROP TABLE `02681_undrop_no_uuid_on_cluster` ON CLUSTER test_shard_localhost FORMAT Null;

SELECT *
FROM `02681_undrop_no_uuid_on_cluster`
ORDER BY id ASC;

DROP TABLE `02681_undrop_no_uuid_on_cluster` ON CLUSTER test_shard_localhost SYNC FORMAT Null;

DROP TABLE IF EXISTS `02681_undrop_replicatedmergetree` SYNC;

CREATE TABLE `02681_undrop_replicatedmergetree`
(
    id Int32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/02681_undrop_replicatedmergetree', 'test_undrop')
ORDER BY id;

INSERT INTO `02681_undrop_replicatedmergetree`;

DROP TABLE `02681_undrop_replicatedmergetree`;

SELECT table
FROM `system`.dropped_tables
WHERE table = '02681_undrop_replicatedmergetree'
LIMIT 1;

UNDROP TABLE `02681_undrop_replicatedmergetree`;

SELECT *
FROM `02681_undrop_replicatedmergetree`
ORDER BY id ASC;

DROP TABLE `02681_undrop_replicatedmergetree` SYNC;

DROP TABLE IF EXISTS `02681_undrop_log` SYNC;

CREATE TABLE `02681_undrop_log`
(
    id Int32
)
ENGINE = Log();

INSERT INTO `02681_undrop_log`;

DROP TABLE `02681_undrop_log`;

SELECT table
FROM `system`.dropped_tables
WHERE table = '02681_undrop_log'
LIMIT 1;

UNDROP TABLE `02681_undrop_log`;

SELECT *
FROM `02681_undrop_log`
ORDER BY id ASC;

DROP TABLE `02681_undrop_log` SYNC;

DROP TABLE IF EXISTS `02681_undrop_distributed` SYNC;

CREATE TABLE `02681_undrop_distributed`
(
    id Int32
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), `02681_undrop`, rand());

DROP TABLE `02681_undrop_distributed`;

SELECT table
FROM `system`.dropped_tables
WHERE table = '02681_undrop_distributed'
LIMIT 1;

UNDROP TABLE `02681_undrop_distributed`;

DROP TABLE `02681_undrop_distributed` SYNC;

DROP TABLE IF EXISTS `02681_undrop_multiple` SYNC;

CREATE TABLE `02681_undrop_multiple`
(
    id Int32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO `02681_undrop_multiple`;

DROP TABLE `02681_undrop_multiple`;

INSERT INTO `02681_undrop_multiple`;

INSERT INTO `02681_undrop_multiple`;

SELECT table
FROM `system`.dropped_tables
WHERE table = '02681_undrop_multiple'
LIMIT 1;

UNDROP TABLE `02681_undrop_multiple`;

SELECT *
FROM `02681_undrop_multiple`
ORDER BY id ASC;

DROP TABLE `02681_undrop_multiple` SYNC;