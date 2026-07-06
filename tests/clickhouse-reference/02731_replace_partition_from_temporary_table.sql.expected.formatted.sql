-- Tags: no-replicated-database, no-shared-merge-tree
-- SharedMergeTree doesn't support replace partition from MergeTree engine
DROP TEMPORARY TABLE IF EXISTS src;

DROP TABLE IF EXISTS dst;

DROP TABLE IF EXISTS rdst;

CREATE TEMPORARY TABLE src
(
    p UInt64,
    k String,
    d UInt64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY p;

CREATE TABLE dst
(
    p UInt64,
    k String,
    d UInt64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY p;

CREATE TABLE rdst
(
    p UInt64,
    k String,
    d UInt64
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_alter_attach_00626_rdst', 'r1')
ORDER BY k
PARTITION BY p;

INSERT INTO src;

INSERT INTO src;

INSERT INTO src;

INSERT INTO src;

INSERT INTO src;

INSERT INTO src;

INSERT INTO dst;

INSERT INTO dst;

INSERT INTO dst;

INSERT INTO dst;

INSERT INTO rdst;

INSERT INTO rdst;

INSERT INTO rdst;

INSERT INTO rdst;

SELECT
    count(),
    sum(d)
FROM dst;

SELECT
    count(),
    sum(d)
FROM rdst;

ALTER TABLE dst REPLACE PARTITION 1 FROM src;

ALTER TABLE rdst REPLACE PARTITION 3 FROM src;

ALTER TABLE dst DROP PARTITION 1;

ALTER TABLE dst ATTACH PARTITION 1 FROM src;

ALTER TABLE rdst DROP PARTITION 3;

ALTER TABLE rdst ATTACH PARTITION 1 FROM src;