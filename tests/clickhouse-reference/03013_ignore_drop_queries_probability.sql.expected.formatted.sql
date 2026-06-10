-- Tags: memory-engine
CREATE TABLE test_memory
(
    number UInt64
)
ENGINE = Memory();

INSERT INTO test_memory SELECT 42;

DROP TABLE test_memory SETTINGS ignore_drop_queries_probability = '1';

SELECT *
FROM test_memory;

DROP TABLE test_memory;

CREATE TABLE test_merge_tree
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY number;

INSERT INTO test_merge_tree SELECT 42;

DROP TABLE test_merge_tree SETTINGS ignore_drop_queries_probability = '1';

SELECT *
FROM test_merge_tree;

DROP TABLE test_merge_tree;

CREATE TABLE test_join
(
    number UInt64
)
ENGINE = Join(`ALL`, `LEFT`, number);

INSERT INTO test_join SELECT 42;

DROP TABLE test_join SETTINGS ignore_drop_queries_probability = '1';

SELECT *
FROM test_join;

DROP TABLE test_join;