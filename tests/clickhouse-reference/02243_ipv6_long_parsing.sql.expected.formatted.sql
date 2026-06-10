DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    id UInt64,
    value IPv6
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_table;

INSERT INTO test_table;

INSERT INTO test_table;

SELECT *
FROM test_table
ORDER BY id ASC;

DROP TABLE test_table;