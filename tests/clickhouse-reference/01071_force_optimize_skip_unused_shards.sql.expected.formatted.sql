-- Tags: shard
SET optimize_skip_unused_shards = '1';

DROP TABLE IF EXISTS data_01071;

DROP TABLE IF EXISTS dist_01071;

DROP TABLE IF EXISTS data2_01071;

DROP TABLE IF EXISTS dist2_01071;

DROP TABLE IF EXISTS dist2_layer_01071;

CREATE TABLE data_01071
(
    key Int
)
ENGINE = Null();

CREATE TABLE dist_01071 AS data_01071
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01071);

SET force_optimize_skip_unused_shards = '0';

SELECT *
FROM dist_01071;

SET force_optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '2';

CREATE TABLE dist_01071 AS data_01071
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01071, key % 2);

-- non deterministic function (i.e. rand())
CREATE TABLE dist_01071 AS data_01071
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01071, key + rand());

SELECT *
FROM dist_01071
WHERE key = 0; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

-- Distributed on Distributed
SET distributed_group_by_no_merge = '1';

CREATE TABLE data2_01071
(
    key Int,
    sub_key Int
)
ENGINE = Null();

CREATE TABLE dist2_layer_01071 AS data2_01071
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data2_01071, sub_key % 2);

CREATE TABLE dist2_01071 AS data2_01071
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), dist2_layer_01071, key % 2);

SELECT *
FROM dist2_01071
WHERE key = 1; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

SET force_optimize_skip_unused_shards_nesting = '1';