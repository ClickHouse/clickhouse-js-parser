-- Tags: shard
SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '2';

SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS data_01270;

DROP TABLE IF EXISTS dist_01270;

CREATE TABLE data_01270
(
    key LowCardinality(Int)
)
ENGINE = Null();

CREATE TABLE dist_01270 AS data_01270
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01270, key);

SELECT *
FROM dist_01270
WHERE key = 1;

DROP TABLE data_01270;

DROP TABLE dist_01270;