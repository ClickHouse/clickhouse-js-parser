-- Tags: long, replica, no-replicated-database, no-parallel, no-object-storage
-- Tag no-replicated-database: Fails due to additional replicas or shards
-- Tag no-parallel: static zk path
DROP TABLE IF EXISTS execute_on_single_replica_r1 SYNC;

DROP TABLE IF EXISTS execute_on_single_replica_r2 SYNC;

/* that test requires fixed zookeeper path, so we cannot use ReplicatedMergeTree({database}) */
CREATE TABLE execute_on_single_replica_r1
(
    x UInt64
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test_01532/execute_on_single_replica', 'r1')
ORDER BY tuple()
SETTINGS execute_merges_on_single_replica_time_threshold = '10';

CREATE TABLE execute_on_single_replica_r2
(
    x UInt64
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test_01532/execute_on_single_replica', 'r2')
ORDER BY tuple()
SETTINGS execute_merges_on_single_replica_time_threshold = '10';

INSERT INTO execute_on_single_replica_r1 SETTINGS insert_keeper_fault_injection_probability = '0';

SYSTEM SYNC REPLICA execute_on_single_replica_r2;

SET optimize_throw_if_noop = '1';

/* all_0_0_1 - will be merged by r1, and downloaded by r2 */
OPTIMIZE TABLE execute_on_single_replica_r1 FINAL;

/* all_0_0_2 - will be merged by r1, and downloaded by r2 */
OPTIMIZE TABLE execute_on_single_replica_r2 FINAL;

SYSTEM SYNC REPLICA execute_on_single_replica_r1;

SYSTEM STOP REPLICATION QUEUES execute_on_single_replica_r2;

/* all_0_0_5 - should be merged by r2, but it has replication queue stopped, so r1 do the merge */
OPTIMIZE TABLE execute_on_single_replica_r1 FINAL SETTINGS replication_alter_partitions_sync = '0';

/* if we will check immediately we can find the log entry unchecked */
SET function_sleep_max_microseconds_per_block = '10000000';

SELECT *
FROM numbers(4)
WHERE sleepEachRow(1);

/* we can now check that r1 waits for r2 */
SELECT
    table,
    type,
    new_part_name,
    num_postponed > 0 AS has_postpones,
    postpone_reason
FROM `system`.replication_queue
WHERE table LIKE 'execute\\_on\\_single\\_replica\\_r%'
    AND database = currentDatabase()
ORDER BY table ASC
FORMAT Vertical;

/* we have execute_merges_on_single_replica_time_threshold exceeded */
SELECT *
FROM numbers(10)
WHERE sleepEachRow(1);

SYSTEM START REPLICATION QUEUES execute_on_single_replica_r2;

ALTER TABLE execute_on_single_replica_r1 MODIFY SETTING execute_merges_on_single_replica_time_threshold = '0';

ALTER TABLE execute_on_single_replica_r2 MODIFY SETTING execute_merges_on_single_replica_time_threshold = '0';

SET replication_alter_partitions_sync = '2';

SYSTEM FLUSH LOGS part_log;

SELECT
    part_name,
    arraySort(groupArrayIf(table, event_type = 'MergeParts')) AS mergers,
    arraySort(groupArrayIf(table, event_type = 'DownloadPart')) AS fetchers
FROM `system`.part_log
WHERE event_time > now() - 120
    AND table LIKE 'execute\\_on\\_single\\_replica\\_r%'
    AND part_name NOT LIKE '%\\_0'
    AND database = currentDatabase()
GROUP BY part_name
ORDER BY part_name ASC
FORMAT Vertical;

DROP TABLE execute_on_single_replica_r1 SYNC;

DROP TABLE execute_on_single_replica_r2 SYNC;