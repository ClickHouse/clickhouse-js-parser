-- Tags: zookeeper
SET insert_keeper_fault_injection_probability = '0'; -- disable fault injection; part ids are non-deterministic in case of insert retries

SET send_logs_level = 'error';

DROP TABLE IF EXISTS mt;

DROP TABLE IF EXISTS rmt SYNC;

CREATE TABLE mt
(
    n UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY n
PARTITION BY intDiv(n, 10);

INSERT INTO mt;

CREATE TABLE rmt
(
    n UInt64,
    s String
)
ENGINE = ReplicatedMergeTree('/clickhouse/test_01149_{database}/rmt', 'r1')
ORDER BY n
PARTITION BY intDiv(n, 10);

INSERT INTO rmt;

SELECT *
FROM rmt;

SELECT *
FROM mt;

SELECT
    table,
    partition_id,
    name,
    `rows`
FROM `system`.parts
WHERE database = currentDatabase()
    AND table IN ('mt', 'rmt')
    AND active = 1
ORDER BY
    table ASC,
    name ASC;

SET mutations_sync = '1';

ALTER TABLE rmt UPDATE s = 's' || toString(n) WHERE 1;

ALTER TABLE rmt REPLACE PARTITION '0' FROM mt;

SYSTEM SYNC REPLICA rmt;

ALTER TABLE rmt DROP COLUMN s;

SELECT
    mutation_id,
    command,
    parts_to_do_names,
    parts_to_do,
    is_done
FROM `system`.mutations
WHERE database = currentDatabase()
    AND table = 'rmt';

DROP TABLE rmt SYNC;

SET replication_alter_partitions_sync = '0';

INSERT INTO rmt;

ALTER TABLE rmt DROP PARTITION '0';

SET replication_alter_partitions_sync = '1';

DROP TABLE mt;