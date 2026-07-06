-- Tags: long, replica, no-shared-merge-tree
-- no-shared-merge-tree: different synchronization
SET replication_alter_partitions_sync = '2';

SET insert_keeper_fault_injection_probability = '0';

DROP TABLE IF EXISTS not_partitioned_replica1_00502 SYNC;

DROP TABLE IF EXISTS not_partitioned_replica2_00502 SYNC;

CREATE TABLE not_partitioned_replica1_00502
(
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/not_partitioned_00502', '1')
ORDER BY x;

CREATE TABLE not_partitioned_replica2_00502
(
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/not_partitioned_00502', '2')
ORDER BY x;

INSERT INTO not_partitioned_replica1_00502;

INSERT INTO not_partitioned_replica1_00502;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'not_partitioned_replica1_00502'
    AND active
ORDER BY name ASC;

SYSTEM SYNC REPLICA not_partitioned_replica1_00502 PULL;

SYSTEM SYNC REPLICA not_partitioned_replica2_00502;

OPTIMIZE TABLE not_partitioned_replica1_00502 PARTITION tuple() FINAL;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'not_partitioned_replica2_00502'
    AND active
ORDER BY name ASC;

SELECT sum(x)
FROM not_partitioned_replica2_00502;

ALTER TABLE not_partitioned_replica1_00502 DETACH PARTITION ID 'all';

DROP TABLE not_partitioned_replica1_00502 SYNC;

DROP TABLE not_partitioned_replica2_00502 SYNC;

DROP TABLE IF EXISTS partitioned_by_week_replica1 SYNC;

DROP TABLE IF EXISTS partitioned_by_week_replica2 SYNC;

CREATE TABLE partitioned_by_week_replica1
(
    d Date,
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/partitioned_by_week_00502', '1')
ORDER BY x
PARTITION BY toMonday(d);

CREATE TABLE partitioned_by_week_replica2
(
    d Date,
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/partitioned_by_week_00502', '2')
ORDER BY x
PARTITION BY toMonday(d);

-- 2000-01-03 belongs to a different week than 2000-01-01 and 2000-01-02
INSERT INTO partitioned_by_week_replica1;

INSERT INTO partitioned_by_week_replica1;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_week_replica1'
    AND active
ORDER BY name ASC;

SYSTEM SYNC REPLICA partitioned_by_week_replica1 PULL;

SYSTEM SYNC REPLICA partitioned_by_week_replica2;

OPTIMIZE TABLE partitioned_by_week_replica1 PARTITION '2000-01-03' FINAL;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_week_replica2'
    AND active
ORDER BY name ASC;

SELECT sum(x)
FROM partitioned_by_week_replica2;

ALTER TABLE partitioned_by_week_replica1 DROP PARTITION '1999-12-27';

DROP TABLE partitioned_by_week_replica1 SYNC;

DROP TABLE partitioned_by_week_replica2 SYNC;

DROP TABLE IF EXISTS partitioned_by_tuple_replica1_00502 SYNC;

DROP TABLE IF EXISTS partitioned_by_tuple_replica2_00502 SYNC;

CREATE TABLE partitioned_by_tuple_replica1_00502
(
    d Date,
    x UInt8,
    y UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/partitioned_by_tuple_00502', '1')
ORDER BY x
PARTITION BY (d, x);

CREATE TABLE partitioned_by_tuple_replica2_00502
(
    d Date,
    x UInt8,
    y UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/partitioned_by_tuple_00502', '2')
ORDER BY x
PARTITION BY (d, x);

INSERT INTO partitioned_by_tuple_replica1_00502;

INSERT INTO partitioned_by_tuple_replica1_00502;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_tuple_replica1_00502'
    AND active
ORDER BY name ASC;

SYSTEM SYNC REPLICA partitioned_by_tuple_replica1_00502 PULL;

SYSTEM SYNC REPLICA partitioned_by_tuple_replica2_00502;

OPTIMIZE TABLE partitioned_by_tuple_replica1_00502 PARTITION ('2000-01-01', 1) FINAL;

OPTIMIZE TABLE partitioned_by_tuple_replica1_00502 PARTITION ('2000-01-02', 1) FINAL;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_tuple_replica2_00502'
    AND active
ORDER BY name ASC;

SELECT sum(y)
FROM partitioned_by_tuple_replica2_00502;

ALTER TABLE partitioned_by_tuple_replica1_00502 DETACH PARTITION ID '20000101-1';

DROP TABLE partitioned_by_tuple_replica1_00502 SYNC;

DROP TABLE partitioned_by_tuple_replica2_00502 SYNC;

DROP TABLE IF EXISTS partitioned_by_string_replica1 SYNC;

DROP TABLE IF EXISTS partitioned_by_string_replica2 SYNC;

CREATE TABLE partitioned_by_string_replica1
(
    s String,
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/partitioned_by_string_00502', '1')
ORDER BY x
PARTITION BY s;

CREATE TABLE partitioned_by_string_replica2
(
    s String,
    x UInt8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/partitioned_by_string_00502', '2')
ORDER BY x
PARTITION BY s;

INSERT INTO partitioned_by_string_replica1;

INSERT INTO partitioned_by_string_replica1;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_string_replica1'
    AND active
ORDER BY name ASC;

SYSTEM SYNC REPLICA partitioned_by_string_replica1 PULL;

SYSTEM SYNC REPLICA partitioned_by_string_replica2;

OPTIMIZE TABLE partitioned_by_string_replica2 PARTITION 'aaa' FINAL;

SELECT
    `partition`,
    name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'partitioned_by_string_replica2'
    AND active
ORDER BY name ASC;

SELECT sum(x)
FROM partitioned_by_string_replica2;

ALTER TABLE partitioned_by_string_replica1 DROP PARTITION 'bbb';

DROP TABLE partitioned_by_string_replica1 SYNC;

DROP TABLE partitioned_by_string_replica2 SYNC;

DROP TABLE IF EXISTS without_fixed_size_columns_replica1 SYNC;

DROP TABLE IF EXISTS without_fixed_size_columns_replica2 SYNC;

CREATE TABLE without_fixed_size_columns_replica1
(
    s String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/without_fixed_size_columns_00502', '1')
ORDER BY s
PARTITION BY length(s);

CREATE TABLE without_fixed_size_columns_replica2
(
    s String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test/without_fixed_size_columns_00502', '2')
ORDER BY s
PARTITION BY length(s);

INSERT INTO without_fixed_size_columns_replica1;

-- Wait for replication.
SYSTEM SYNC REPLICA without_fixed_size_columns_replica1 PULL;

SYSTEM SYNC REPLICA without_fixed_size_columns_replica2;

OPTIMIZE TABLE without_fixed_size_columns_replica2 PARTITION 1 FINAL;

SELECT
    `partition`,
    name,
    `rows`
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'without_fixed_size_columns_replica2'
    AND active
ORDER BY name ASC;

SELECT *
FROM without_fixed_size_columns_replica2
ORDER BY s ASC;

ALTER TABLE without_fixed_size_columns_replica1 DROP PARTITION 1;

DROP TABLE without_fixed_size_columns_replica1 SYNC;

DROP TABLE without_fixed_size_columns_replica2 SYNC;