DROP TABLE IF EXISTS test;

DROP TABLE IF EXISTS test2;

CREATE TABLE test
(
    s String
)
ENGINE = MergeTree()
ORDER BY s
SETTINGS index_granularity = '1', use_primary_key_cache = '0';

CREATE TABLE test2
(
    s String
)
ENGINE = MergeTree()
ORDER BY s
SETTINGS index_granularity = '1', use_primary_key_cache = '0';

INSERT INTO test SELECT randomString(1000)
FROM numbers(100000);

SELECT
    round(primary_key_bytes_in_memory, -7),
    round(primary_key_bytes_in_memory_allocated, -7)
FROM `system`.parts
WHERE database = currentDatabase()
    AND table IN ('test', 'test2');

INSERT INTO test2 SELECT randomString(1000)
FROM numbers(100000);

SYSTEM UNLOAD PRIMARY KEY CLICKHOUSE_DATABASE.test;

SYSTEM UNLOAD PRIMARY KEY CLICKHOUSE_DATABASE.test2;

SELECT s != ''
FROM test
LIMIT 1;

SELECT s != ''
FROM test
WHERE s < '99999999'
LIMIT 1;

SELECT s != ''
FROM test2
LIMIT 1;

SELECT s != ''
FROM test2
WHERE s < '99999999'
LIMIT 1;