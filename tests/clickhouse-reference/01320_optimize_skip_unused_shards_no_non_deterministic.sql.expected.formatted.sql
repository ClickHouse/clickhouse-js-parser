-- Tags: shard
DROP TABLE IF EXISTS data_01320;

DROP TABLE IF EXISTS dist_01320;

CREATE TABLE data_01320
(
    key Int
)
ENGINE = Null();

-- non deterministic function (i.e. rand())
CREATE TABLE dist_01320 AS data_01320
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01320, key + rand());

SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '1';

SELECT *
FROM dist_01320
WHERE key = 0; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

DROP TABLE data_01320;

DROP TABLE dist_01320;