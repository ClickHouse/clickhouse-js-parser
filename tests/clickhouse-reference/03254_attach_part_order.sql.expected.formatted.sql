CREATE TABLE test_table
(
    dt DateTime,
    id UInt32,
    url String,
    visits UInt32
)
ENGINE = ReplacingMergeTree()
ORDER BY (dt, id)
PARTITION BY toYYYYMM(dt);

SYSTEM STOP MERGES test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

ALTER TABLE test_table DETACH PARTITION 202410;

ALTER TABLE test_table ATTACH PARTITION 202410;

SELECT
    id,
    visits
FROM test_table FINAL
ORDER BY id ASC
FORMAT Vertical;