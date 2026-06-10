-- Tags: zookeeper, no-random-merge-tree-settings, no-replicated-database
DROP TABLE IF EXISTS x1;

DROP TABLE IF EXISTS x2;

CREATE TABLE x1
(
    i Nullable(int)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/x1', 'r1')
ORDER BY i DESC
SETTINGS allow_nullable_key = '1', index_granularity = '2', index_granularity_bytes = '10000', allow_experimental_reverse_key = '1';

CREATE TABLE x2
(
    i Nullable(int),
    j Nullable(int)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/x2', 'r1')
ORDER BY (i, j DESC)
SETTINGS allow_nullable_key = '1', index_granularity = '2', index_granularity_bytes = '10000', allow_experimental_reverse_key = '1';

SET allow_unrestricted_reads_from_keeper = 'true';

SELECT value
FROM `system`.zookeeper
WHERE path = '/clickhouse/tables/' || currentDatabase() || '/x1'
    AND name = 'metadata';

SELECT value
FROM `system`.zookeeper
WHERE path = '/clickhouse/tables/' || currentDatabase() || '/x2'
    AND name = 'metadata';

DROP TABLE x1;

DROP TABLE x2;