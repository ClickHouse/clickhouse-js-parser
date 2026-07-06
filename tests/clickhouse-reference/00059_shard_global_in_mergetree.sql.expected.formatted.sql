-- Tags: shard
-- test for #56790
DROP TABLE IF EXISTS test_local;

CREATE TABLE test_local
(
    x Int64
)
ENGINE = MergeTree()
ORDER BY x AS
SELECT *
FROM numbers(10);

SELECT count()
FROM remote('127.0.0.1,127.0.0.2', currentDatabase(), test_local);

SELECT count()
FROM remote('127.0.0.1,127.0.0.2', currentDatabase(), test_local)
WHERE 'XXX' GLOBAL IN (
        SELECT 'XXX'
    );

SELECT count()
FROM remote('127.0.0.1,127.0.0.2', currentDatabase(), test_local)
WHERE * GLOBAL IN (
        SELECT *
        FROM numbers(10)
    );

SELECT count()
FROM remote('127.0.0.1,127.0.0.2', currentDatabase(), test_local)
WHERE * IN (
        SELECT *
        FROM numbers(10)
    );

SET prefer_localhost_replica = '0';

DROP TABLE test_local;