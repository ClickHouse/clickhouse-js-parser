-- Tags: shard
DROP TABLE IF EXISTS dist_01528;

CREATE TABLE dist_01528 AS `system`.one
ENGINE = Distributed('test_cluster_two_shards', `system`, one, rand() + dummy);

SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '1';

SELECT *
FROM dist_01528
WHERE dummy = 2; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

SELECT *
FROM dist_01528
WHERE dummy = 2
SETTINGS allow_nondeterministic_optimize_skip_unused_shards = '1';

DROP TABLE dist_01528;