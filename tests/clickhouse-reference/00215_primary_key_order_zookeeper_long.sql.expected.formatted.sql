-- Tags: long, zookeeper, no-replicated-database, no-shared-merge-tree, no-async-insert
-- Tag no-replicated-database: Old syntax is not allowed
-- no-shared-merge-tree: implemented replacement
-- Tag no-async-insert: async insert calculate deduplicate block differently, it takes all inserted blocks into account as it is, the order is is matteer here
DROP TABLE IF EXISTS primary_key;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE primary_key
(
    d Date DEFAULT today(),
    x Int8
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00215/primary_key', 'r1', d, -x, 1);

INSERT INTO primary_key (x);

INSERT INTO primary_key (x);

INSERT INTO primary_key (x);

INSERT INTO primary_key (x);

INSERT INTO primary_key (x);

INSERT INTO primary_key (x);

SELECT x
FROM primary_key
ORDER BY x ASC;

SELECT x
FROM primary_key
WHERE -x < -1
ORDER BY x ASC;

DROP TABLE primary_key;