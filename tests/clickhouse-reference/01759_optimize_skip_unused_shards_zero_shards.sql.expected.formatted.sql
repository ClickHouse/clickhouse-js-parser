-- Tags: shard
-- { echo }
SELECT *
FROM remote('127.{1,2}', `system`, one, dummy)
WHERE 0
SETTINGS
    optimize_skip_unused_shards = '1',
    force_optimize_skip_unused_shards = '1';

SELECT count()
FROM remote('127.{1,2}', `system`, one, dummy)
WHERE 0
SETTINGS
    optimize_skip_unused_shards = '1',
    force_optimize_skip_unused_shards = '1';