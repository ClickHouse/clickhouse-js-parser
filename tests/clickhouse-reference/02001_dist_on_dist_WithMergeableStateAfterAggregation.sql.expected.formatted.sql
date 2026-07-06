DROP TABLE IF EXISTS dist;

CREATE TABLE dist AS `system`.one
ENGINE = Distributed('test_shard_localhost', `system`, one);

-- { echo }
SELECT dummy AS foo
FROM remote('127.{2,3}', currentDatabase(), dist)
LIMIT 1
SETTINGS
    prefer_localhost_replica = '0',
    distributed_push_down_limit = '0';

SELECT dummy AS foo
FROM remote('127.{2,3}', currentDatabase(), dist)
LIMIT 1
SETTINGS
    prefer_localhost_replica = '0',
    distributed_push_down_limit = '1';

SELECT dummy AS foo
FROM remote('127.{2,3}', currentDatabase(), dist)
LIMIT 1
SETTINGS
    prefer_localhost_replica = '0',
    distributed_group_by_no_merge = '1';