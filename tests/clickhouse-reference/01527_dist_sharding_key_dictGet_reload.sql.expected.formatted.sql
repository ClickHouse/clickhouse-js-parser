-- Tags: shard, no-parallel
SET allow_nondeterministic_optimize_skip_unused_shards = '1';

SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '2';

SET check_table_dependencies = '0';

DROP DATABASE IF EXISTS db_01527_ranges;

DROP TABLE IF EXISTS dist_01527;

DROP TABLE IF EXISTS data_01527;

CREATE DATABASE db_01527_ranges;

CREATE TABLE data_01527
ENGINE = Memory() AS
SELECT toUInt64(number) AS key
FROM numbers(2);

CREATE TABLE dist_01527 AS data_01527
ENGINE = Distributed('test_cluster_two_shards', currentDatabase(), data_01527, dictGetUInt64('db_01527_ranges.dict', 'shard', key));

CREATE TABLE db_01527_ranges.data
ENGINE = Memory() AS
SELECT
    number AS key,
    number AS shard
FROM numbers(100);

CREATE DICTIONARY db_01527_ranges.dict
(
    key UInt64,
    shard UInt64
)
PRIMARY KEY key
SOURCE(clickhouse(HOST '127.0.0.1' PORT tcpPort() TABLE 'data' DB 'db_01527_ranges' USER 'default' PASSWORD ''))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SYSTEM RELOAD DICTIONARY db_01527_ranges.dict;

SELECT _shard_num
FROM dist_01527
WHERE key = 0;

SELECT _shard_num
FROM dist_01527
WHERE key = 1;

DROP TABLE db_01527_ranges.data SYNC;

CREATE TABLE db_01527_ranges.data
ENGINE = Memory() AS
SELECT
    number AS key,
    number + 1 AS shard
FROM numbers(100);

DROP TABLE data_01527;

DROP TABLE dist_01527;

DROP TABLE db_01527_ranges.data;

DROP DICTIONARY db_01527_ranges.dict;

DROP DATABASE db_01527_ranges;