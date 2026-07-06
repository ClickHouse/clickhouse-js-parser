-- Tags: long, replica
--- See also tests/queries/0_stateless/01581_deduplicate_by_columns_local.sql
--- replicated case
-- Just in case if previous tests run left some stuff behind.
DROP TABLE IF EXISTS replicated_deduplicate_by_columns_r1 SYNC;

DROP TABLE IF EXISTS replicated_deduplicate_by_columns_r2 SYNC;

SET replication_alter_partitions_sync = '2';

-- IRL insert_replica_id were filled from hostname
CREATE TABLE IF NOT EXISTS replicated_deduplicate_by_columns_r1
(
    id Int32,
    val UInt32,
    unique_value UInt64 MATERIALIZED rowNumberInBlock()
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_01581/replicated_deduplicate', 'r1')
ORDER BY id;

CREATE TABLE IF NOT EXISTS replicated_deduplicate_by_columns_r2
(
    id Int32,
    val UInt32,
    unique_value UInt64 MATERIALIZED rowNumberInBlock()
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_01581/replicated_deduplicate', 'r2')
ORDER BY id;

-- insert some data, 2 records: (3, 1003), (4, 1004) are duplicated and have difference in unique_value / insert_replica_id
-- (1, 1001), (5, 2005) has full duplicates
INSERT INTO replicated_deduplicate_by_columns_r1;

INSERT INTO replicated_deduplicate_by_columns_r2;

-- make sure that all data is present on all replicas
SYSTEM SYNC REPLICA replicated_deduplicate_by_columns_r2;

SYSTEM SYNC REPLICA replicated_deduplicate_by_columns_r1;

SELECT
    'r1',
    id,
    val,
    count(),
    uniqExact(unique_value)
FROM replicated_deduplicate_by_columns_r1
GROUP BY
    id,
    val
ORDER BY
    id ASC,
    val ASC;

SELECT
    'r2',
    id,
    val,
    count(),
    uniqExact(unique_value)
FROM replicated_deduplicate_by_columns_r2
GROUP BY
    id,
    val
ORDER BY
    id ASC,
    val ASC;

-- NOTE: here and below we need FINAL to force deduplication in such a small set of data in only 1 part.
-- that should remove full duplicates
OPTIMIZE TABLE replicated_deduplicate_by_columns_r1 FINAL DEDUPLICATE;

OPTIMIZE TABLE replicated_deduplicate_by_columns_r1 FINAL DEDUPLICATE BY id, val;

OPTIMIZE TABLE replicated_deduplicate_by_columns_r1 FINAL DEDUPLICATE BY COLUMNS('[id, val]');

OPTIMIZE TABLE replicated_deduplicate_by_columns_r1 FINAL DEDUPLICATE BY COLUMNS('[i]') EXCEPT (unique_value);

-- cleanup the mess
DROP TABLE replicated_deduplicate_by_columns_r1;

DROP TABLE replicated_deduplicate_by_columns_r2;