DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    key UInt32,
    arr ALIAS [1, 2],
    xx MATERIALIZED arr[1]
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple();

DROP TABLE test;

CREATE TABLE test
(
    key UInt32,
    arr Array(UInt32) ALIAS [1, 2],
    xx MATERIALIZED arr[1]
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple();

CREATE TABLE test
(
    key UInt32,
    arr Array(UInt32) ALIAS [1, 2],
    xx UInt32 MATERIALIZED arr[1]
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple();

CREATE TABLE test
(
    key UInt32,
    arr ALIAS [1, 2]
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple();

ALTER TABLE test ADD COLUMN xx UInt32 MATERIALIZED arr[1];