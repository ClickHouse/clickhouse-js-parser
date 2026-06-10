-- Tags: shard
DROP TABLE IF EXISTS data_01072;

DROP TABLE IF EXISTS dist_01072;

SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '1';

CREATE TABLE data_01072
(
    key Int,
    value Int,
    str String
)
ENGINE = Null();

CREATE TABLE dist_01072
(
    key Int,
    value Int,
    str String
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01072, key % 2);

SELECT *
FROM dist_01072
WHERE key = 0
    AND length(str) = 0;

SELECT *
FROM dist_01072
WHERE key = 0
    AND str = '';

SELECT *
FROM dist_01072
WHERE xxHash64(0) = xxHash64(0)
    AND key = 0;

SELECT *
FROM dist_01072
WHERE key = toInt32OrZero(toString(xxHash64(0)));

SELECT *
FROM dist_01072
WHERE key = toInt32(xxHash32(0));

SELECT *
FROM dist_01072
WHERE key = toInt32(toInt32(xxHash32(0)));

SELECT *
FROM dist_01072
WHERE key = toInt32(toInt32(toInt32(xxHash32(0))));

SELECT *
FROM dist_01072
WHERE key = value; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

SELECT *
FROM dist_01072
WHERE key = toInt32(value); -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

SELECT *
FROM dist_01072
WHERE key = value
SETTINGS force_optimize_skip_unused_shards = '0';

SELECT *
FROM dist_01072
WHERE key = toInt32(value)
SETTINGS force_optimize_skip_unused_shards = '0';

DROP TABLE dist_01072;

CREATE TABLE dist_01072
(
    key Int,
    value Nullable(Int),
    str String
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01072, key % 2);

SET allow_suspicious_low_cardinality_types = '1';

CREATE TABLE dist_01072
(
    key Int,
    value LowCardinality(Int),
    str String
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01072, key % 2);

CREATE TABLE dist_01072
(
    key Int,
    value LowCardinality(Nullable(Int)),
    str String
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01072, key % 2);

-- check virtual columns
DROP TABLE data_01072;

CREATE TABLE data_01072
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key;

CREATE TABLE dist_01072
(
    key Int
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01072, key);

SELECT *
FROM dist_01072
WHERE key = 0
    AND _part = '0'
SETTINGS force_optimize_skip_unused_shards = '2';