-- Tags: distributed
SET enable_memory_bound_merging_of_aggregation_results = '0';

DROP TABLE IF EXISTS projection_test;

CREATE TABLE projection_test
(
    dt DateTime,
    cost Int64,
    PROJECTION p (SELECT toStartOfMinute(dt) AS dt_m, sum(cost) GROUP BY dt_m)
)
ENGINE = MergeTree()
ORDER BY dt
PARTITION BY toDate(dt);

INSERT INTO projection_test WITH rowNumberInAllBlocks() AS id

SELECT
    toDateTime('2020-10-24 00:00:00') + id / 20,
    *
FROM generateRandom('cost Int64', 10, 10, 1)
LIMIT 1000
SETTINGS max_threads = '1';

SET optimize_use_projections = '1', force_optimize_projection = '1';

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SELECT
    toStartOfMinute(dt) AS dt_m,
    sum(cost)
FROM projection_test
GROUP BY dt_m;

SELECT sum(cost)
FROM projection_test;

DROP TABLE IF EXISTS projection_test_d;

CREATE TABLE projection_test_d
(
    dt DateTime,
    cost Int64
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), projection_test);

SELECT
    toStartOfMinute(dt) AS dt_m,
    sum(cost)
FROM projection_test_d
GROUP BY dt_m;

SELECT sum(cost)
FROM projection_test_d;

DROP TABLE projection_test;

DROP TABLE projection_test_d;