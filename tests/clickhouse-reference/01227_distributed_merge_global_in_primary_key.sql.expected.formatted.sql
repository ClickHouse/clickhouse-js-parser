-- https://github.com/ClickHouse/ClickHouse/issues/64211
DROP TABLE IF EXISTS test_merge;

DROP TABLE IF EXISTS test_merge_distributed;

DROP TABLE IF EXISTS test_distributed_merge;

DROP TABLE IF EXISTS test_distributed;

DROP TABLE IF EXISTS test_local;

CREATE TABLE test_local
(
    name String
)
ENGINE = MergeTree()
ORDER BY name AS
SELECT 'x';

CREATE TABLE test_distributed AS test_local
ENGINE = Distributed(test_shard_localhost, currentDatabase(), test_local);

CREATE TABLE test_merge AS test_local
ENGINE = Merge(currentDatabase(), 'test_local');

CREATE TABLE test_merge_distributed AS test_local
ENGINE = Distributed(test_shard_localhost, currentDatabase(), test_merge);

CREATE TABLE test_distributed_merge AS test_local
ENGINE = Merge(currentDatabase(), 'test_distributed');

SELECT '------------------- Distributed ------------------';

SELECT count()
FROM test_distributed
WHERE name GLOBAL IN (
        SELECT name
        FROM test_distributed
    );

SELECT count()
FROM merge(currentDatabase(), 'test_distributed')
WHERE name GLOBAL IN (
        SELECT name
        FROM test_distributed
    );

SELECT count()
FROM merge(currentDatabase(), 'test_local')
WHERE name GLOBAL IN (
        SELECT name
        FROM test_distributed
    );

SELECT count()
FROM merge(currentDatabase(), 'test_local')
WHERE name GLOBAL IN (
        SELECT name
        FROM merge(currentDatabase(), 'test_local')
    );

SELECT count()
FROM merge(currentDatabase(), 'test_local')
WHERE name GLOBAL IN (
        SELECT name
        FROM remote('127.0.0.{1,2}', currentDatabase(), test_merge)
    );

SELECT count()
FROM remote('127.0.0.{1,2}', currentDatabase(), test_merge)
WHERE name GLOBAL IN (
        SELECT name
        FROM test_distributed
    );

SELECT count()
FROM test_merge_distributed
WHERE name GLOBAL IN (
        SELECT name
        FROM test_merge_distributed
    );

SELECT count()
FROM remote('127.0.0.{1,2}', currentDatabase(), test_merge)
WHERE name GLOBAL IN (
        SELECT name
        FROM remote('127.0.0.{1,2}', currentDatabase(), test_merge)
    );

SELECT count()
FROM test_distributed_merge
WHERE name GLOBAL IN (
        SELECT name
        FROM remote('127.0.0.{1,2}', currentDatabase(), test_merge)
    );

SELECT count()
FROM test_distributed_merge
WHERE name GLOBAL IN (
        SELECT name
        FROM remote('127.0.0.{1,2}', currentDatabase(), test_distributed_merge)
    );

SELECT count()
FROM test_distributed_merge
WHERE name GLOBAL IN (
        SELECT name
        FROM test_distributed_merge
    );

SELECT count()
FROM remote('127.0.0.{1,2}', currentDatabase(), test_distributed_merge)
WHERE name GLOBAL IN (
        SELECT name
        FROM remote('127.0.0.{1,2}', currentDatabase(), test_merge)
    );

DROP TABLE test_merge;

DROP TABLE test_merge_distributed;

DROP TABLE test_distributed_merge;

DROP TABLE test_distributed;

DROP TABLE test_local;