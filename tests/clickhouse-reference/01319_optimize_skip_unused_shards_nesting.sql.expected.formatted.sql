-- Tags: shard
DROP TABLE IF EXISTS data_01319;

DROP TABLE IF EXISTS dist_01319;

DROP TABLE IF EXISTS dist_layer_01319;

CREATE TABLE data_01319
(
    key Int,
    sub_key Int
)
ENGINE = Null();

CREATE TABLE dist_layer_01319 AS data_01319
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01319, sub_key);

-- test_unavailable_shard here to check that optimize_skip_unused_shards always
-- remove some nodes from the cluster for the first nesting level
CREATE TABLE dist_01319 AS data_01319
ENGINE = Distributed(test_unavailable_shard, currentDatabase(), dist_layer_01319, key + 1);

SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards_nesting = '2';

SET optimize_skip_unused_shards_nesting = '2';

SELECT *
FROM dist_01319
WHERE key = 1; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

SET force_optimize_skip_unused_shards_nesting = '1';

SET optimize_skip_unused_shards_nesting = '1';

DROP TABLE data_01319;

DROP TABLE dist_01319;

DROP TABLE dist_layer_01319;