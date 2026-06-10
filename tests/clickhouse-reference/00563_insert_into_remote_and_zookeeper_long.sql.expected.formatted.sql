-- Tags: zookeeper
-- Check that settings are correctly passed through Distributed table
DROP TABLE IF EXISTS simple;

CREATE TABLE simple
(
    d Int8
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test_00563/tables/simple', '1')
ORDER BY d;

INSERT INTO FUNCTION remote('127.0.0.1', currentDatabase(), 'simple') SETTINGS prefer_localhost_replica = '1', insert_deduplicate = '1';

INSERT INTO FUNCTION remote('127.0.0.1', currentDatabase(), 'simple') SETTINGS prefer_localhost_replica = '1', insert_deduplicate = '0', async_insert_deduplicate = '0';

SELECT *
FROM remote('127.0.0.1', currentDatabase(), 'simple')
ORDER BY d ASC;

TRUNCATE TABLE simple;

INSERT INTO FUNCTION remote('127.0.0.1', currentDatabase(), 'simple') SETTINGS prefer_localhost_replica = '0', insert_deduplicate = '1';

INSERT INTO FUNCTION remote('127.0.0.1', currentDatabase(), 'simple') SETTINGS prefer_localhost_replica = '0', insert_deduplicate = '0', async_insert_deduplicate = '0';

SELECT *
FROM remote('127.0.0.2', currentDatabase(), 'simple')
ORDER BY d ASC;

DROP TABLE simple;