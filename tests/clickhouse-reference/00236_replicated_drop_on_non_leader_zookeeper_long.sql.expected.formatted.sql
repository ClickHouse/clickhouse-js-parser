-- Tags: long, replica, no-replicated-database, no-shared-merge-tree
-- Tag no-replicated-database: Old syntax is not allowed
-- no-shared-merge-tree: implemented replacement
SET replication_alter_partitions_sync = '2';

DROP TABLE IF EXISTS attach_r1;

DROP TABLE IF EXISTS attach_r2;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE attach_r1
(
    d Date
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00236/01/attach', 'r1', d, d, 8192);

CREATE TABLE attach_r2
(
    d Date
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00236/01/attach', 'r2', d, d, 8192);

INSERT INTO attach_r1;

SELECT d
FROM attach_r1
ORDER BY d ASC;

ALTER TABLE attach_r2 DROP PARTITION 201402;

DROP TABLE attach_r1;

DROP TABLE attach_r2;