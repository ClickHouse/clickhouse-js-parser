-- Tags: no-parallel
DROP TABLE IF EXISTS test_alter_attach_01901S;

DROP TABLE IF EXISTS test_alter_attach_01901D;

CREATE TABLE test_alter_attach_01901S
(
    A Int64,
    D date
)
ENGINE = MergeTree()
ORDER BY A
PARTITION BY D;

INSERT INTO test_alter_attach_01901S;

CREATE TABLE test_alter_attach_01901D
(
    A Int64,
    D date
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_alter_attach_01901D', 'r1')
ORDER BY A
PARTITION BY D;

ALTER TABLE test_alter_attach_01901D ATTACH PARTITION '2020-01-01' FROM test_alter_attach_01901S;

SELECT count()
FROM test_alter_attach_01901D;

SELECT count()
FROM test_alter_attach_01901S;

ALTER TABLE test_alter_attach_01901D REPLACE PARTITION '2020-01-01' FROM test_alter_attach_01901S;

DROP TABLE test_alter_attach_01901S;

DROP TABLE test_alter_attach_01901D;