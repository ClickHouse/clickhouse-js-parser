-- Tags: shard
-- remote() does not have sharding key, while force_optimize_skip_unused_shards=2 requires from table to have it.
-- But due to only one node, everything works.
SELECT *
FROM remote('127.1', `system`.one)
SETTINGS
    optimize_skip_unused_shards = '1',
    force_optimize_skip_unused_shards = '2'
FORMAT Null;