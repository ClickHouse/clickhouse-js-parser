SET enable_analyzer = '1';

DROP TABLE IF EXISTS test_table_join_1;

CREATE TABLE test_table_join_1
(
    id UInt64,
    value UInt64
)
ENGINE = SummingMergeTree(value)
ORDER BY id
SAMPLE BY id;

SYSTEM STOP MERGES test_table_join_1;

INSERT INTO test_table_join_1;

INSERT INTO test_table_join_1;

DROP TABLE IF EXISTS test_table_join_2;

CREATE TABLE test_table_join_2
(
    id UInt64,
    value UInt64
)
ENGINE = SummingMergeTree(value)
ORDER BY id
SAMPLE BY id;

SYSTEM STOP MERGES test_table_join_2;

INSERT INTO test_table_join_2;

INSERT INTO test_table_join_2;

SELECT
    t1.id AS t1_id,
    t2.id AS t2_id,
    t1.value AS t1_value,
    t2.value AS t2_value
FROM
    test_table_join_1 AS t1 FINAL
INNER JOIN test_table_join_2 AS t2 FINAL
    ON t1.id = t2.id
ORDER BY t1_id ASC;

DROP TABLE test_table_join_1;

DROP TABLE test_table_join_2;