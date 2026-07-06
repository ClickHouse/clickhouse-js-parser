DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    n1 UInt32,
    n2 UInt32 ALIAS murmurHash3_32(n1),
    n3 UInt32 MATERIALIZED n2 + 1
)
ENGINE = MergeTree()
ORDER BY n1;

INSERT INTO test SELECT *
FROM generateRandom()
LIMIT 10;

DROP TABLE test;