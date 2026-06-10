-- Tags: no-parallel
CREATE DATABASE IF NOT EXISTS shard_0;

CREATE DATABASE IF NOT EXISTS shard_1;

DROP TABLE IF EXISTS shard_0.from_1;

DROP TABLE IF EXISTS shard_1.from_1;

DROP TABLE IF EXISTS shard_0.to;

DROP TABLE IF EXISTS shard_1.to;

CREATE TABLE shard_0.from_1
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/from_1_' || currentDatabase(), '0')
ORDER BY x
SETTINGS old_parts_lifetime = '1', max_cleanup_delay_period = '1', cleanup_delay_period = '1', shared_merge_tree_disable_merges_and_mutations_assignment = '1';

CREATE TABLE shard_1.from_1
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/from_1_' || currentDatabase(), '1')
ORDER BY x
SETTINGS old_parts_lifetime = '1', max_cleanup_delay_period = '1', cleanup_delay_period = '1', shared_merge_tree_disable_merges_and_mutations_assignment = '1';

SYSTEM STOP MERGES shard_0.from_1;

SYSTEM STOP MERGES shard_1.from_1;

INSERT INTO shard_0.from_1 SELECT number + 20
FROM numbers(10);

INSERT INTO shard_0.from_1 SELECT number + 30
FROM numbers(10);

INSERT INTO shard_0.from_1 SELECT number + 40
FROM numbers(10);

INSERT INTO shard_0.from_1 SELECT number + 50
FROM numbers(10);

SYSTEM SYNC REPLICA shard_1.from_1;

CREATE TABLE shard_0.to
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/to_' || currentDatabase(), '0')
ORDER BY x
SETTINGS old_parts_lifetime = '1', max_cleanup_delay_period = '1', cleanup_delay_period = '1', max_parts_to_merge_at_once = '2', shared_merge_tree_disable_merges_and_mutations_assignment = '1';

CREATE TABLE shard_1.to
(
    x UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/to_' || currentDatabase(), '1')
ORDER BY x
SETTINGS old_parts_lifetime = '1', max_cleanup_delay_period = '1', cleanup_delay_period = '1', max_parts_to_merge_at_once = '2';

DETACH TABLE shard_1.to;

ALTER TABLE shard_0.from_1 ON CLUSTER test_cluster_two_shards_different_databases MOVE PARTITION tuple() TO TABLE shard_0.to SETTINGS distributed_ddl_output_mode = 'never_throw', distributed_ddl_task_timeout = '1' FORMAT Null;

OPTIMIZE TABLE shard_0.to;

SELECT
    name,
    active
FROM `system`.parts
WHERE database = 'shard_0'
    AND table = 'to'
    AND active
ORDER BY name ASC;

-- If moved parts are not merged by OPTIMIZE or background merge restart
-- can log Warning about metadata version on disk. It's normal situation
-- and test shouldn't rarely fail because of it.
SET send_logs_level = 'error';

SYSTEM RESTART REPLICA shard_0.to;

-- Doesn't lead to test flakyness, because we don't check content in table
-- which doesn't depend on any background operation
SELECT sleep(3);

ATTACH TABLE shard_1.to;

SYSTEM SYNC REPLICA shard_1.to;

SELECT
    count(),
    sum(x)
FROM shard_1.to;