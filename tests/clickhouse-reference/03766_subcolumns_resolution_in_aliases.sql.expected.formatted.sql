SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a JSON,
    `b.c` JSON,
    ab UInt64 ALIAS a.b,
    bcd UInt64 ALIAS b.c.d
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT
    '{"a" : 42}',
    '{"d" : 43}';

SELECT
    ab,
    bcd
FROM test;

EXPLAIN QUERY TREE
SELECT
    ab,
    bcd
FROM test;

DROP TABLE test;