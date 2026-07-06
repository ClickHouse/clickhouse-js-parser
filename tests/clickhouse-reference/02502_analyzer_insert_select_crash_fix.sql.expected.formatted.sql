SET enable_analyzer = '1';

DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    id UInt64,
    value String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_table SELECT
    0,
    'Value_0';

DROP TABLE IF EXISTS test_table_data;

CREATE TABLE test_table_data
(
    id UInt64,
    value String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_table_data;

INSERT INTO test_table SELECT
    id,
    value
FROM test_table_data;

SELECT
    id,
    value
FROM test_table
ORDER BY id ASC;

DROP TABLE test_table_data;

DROP TABLE test_table;