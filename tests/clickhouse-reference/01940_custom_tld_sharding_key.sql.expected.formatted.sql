-- Tags: shard
SELECT *
FROM remote('127.{1,2}', view(    SELECT 'foo.com' AS key), cityHash64(key))
WHERE key = cutToFirstSignificantSubdomainCustom('foo.com', 'public_suffix_list')
SETTINGS
    optimize_skip_unused_shards = '1',
    force_optimize_skip_unused_shards = '1';

SELECT *
FROM remote('127.{1,2}', view(    SELECT 'foo.com' AS key), cityHash64(key))
WHERE key = cutToFirstSignificantSubdomainCustom('bar.com', 'public_suffix_list')
SETTINGS
    optimize_skip_unused_shards = '1',
    force_optimize_skip_unused_shards = '1';