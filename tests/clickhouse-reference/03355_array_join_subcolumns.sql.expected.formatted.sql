-- Tags: no-parallel-replicas
SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    arr Array(UInt64),
    t Tuple(a Array(UInt32), b Array(UInt32))
)
ENGINE = Memory();

INSERT INTO test SELECT
    [1, 2, 3],
    tuple([1, 2], [1, 2, 3, 4]);

SELECT t.a
FROM
    test
ARRAY JOIN arr;

EXPLAIN QUERY TREE
SELECT t.a
FROM
    test
ARRAY JOIN arr;

SELECT t.a
FROM
    test
ARRAY JOIN t.b;

EXPLAIN QUERY TREE
SELECT t.a
FROM
    test
ARRAY JOIN t.b;

DROP TABLE test;