-- Tags: shard
SELECT
    shardNum() AS n,
    shardCount() AS c;

SELECT
    shardNum() AS n,
    shardCount() AS c
FROM remote('127.0.0.{1,2,3}', `system`.one)
ORDER BY n ASC
SETTINGS prefer_localhost_replica = '0';

SELECT
    shardNum() AS n,
    shardCount() AS c
FROM remote('127.0.0.{1,2,3}', `system`.one)
ORDER BY n ASC
SETTINGS prefer_localhost_replica = '1';