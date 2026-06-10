-- Tags: zookeeper, no-random-merge-tree-settings
DROP TABLE IF EXISTS versioned_collapsing_table;

CREATE TABLE versioned_collapsing_table
(
    d Date,
    key1 UInt64,
    key2 UInt32,
    value String,
    sign Int8,
    version UInt16
)
ENGINE = ReplicatedVersionedCollapsingMergeTree('/clickhouse/{database}/versioned_collapsing_table/{shard}', '{replica}', sign, version)
ORDER BY (key1, key2)
PARTITION BY d;

INSERT INTO versioned_collapsing_table;

SELECT value
FROM `system`.zookeeper
WHERE path = '/clickhouse/' || currentDatabase() || '/versioned_collapsing_table/s1'
    AND name = 'metadata';

SELECT COUNT()
FROM versioned_collapsing_table;

DETACH TABLE versioned_collapsing_table;

ATTACH TABLE versioned_collapsing_table;