-- Tags: shard
SET optimize_skip_unused_shards = '1';

DROP TABLE IF EXISTS data_02000;

DROP TABLE IF EXISTS dist_02000;

CREATE TABLE data_02000
(
    key Int
)
ENGINE = Null();

CREATE TABLE dist_02000 AS data_02000
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_02000, key);

SELECT *
FROM data_02000
WHERE key = 16045690709955428015;

SELECT *
FROM dist_02000
WHERE key = 16045690709955428015
SETTINGS force_optimize_skip_unused_shards = '2'; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS, CANNOT_CONVERT_TYPE }

SELECT *
FROM dist_02000
WHERE key = 16045690709955428015;

DROP TABLE data_02000;

DROP TABLE dist_02000;