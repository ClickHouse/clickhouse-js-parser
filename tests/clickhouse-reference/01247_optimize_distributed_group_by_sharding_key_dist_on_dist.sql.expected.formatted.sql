-- Tags: distributed
-- TODO: correct testing with real unique shards
SET optimize_distributed_group_by_sharding_key = '1';

DROP TABLE IF EXISTS dist_01247;

DROP TABLE IF EXISTS dist_layer_01247;

DROP TABLE IF EXISTS data_01247;

CREATE TABLE data_01247 AS `system`.numbers
ENGINE = Memory();

-- since data is not inserted via distributed it will have duplicates
-- (and this is how we ensure that this optimization will work)
INSERT INTO data_01247 SELECT *
FROM `system`.numbers
LIMIT 2;

SET max_distributed_connections = '1';

SET optimize_skip_unused_shards = '1';

CREATE TABLE dist_layer_01247 AS data_01247
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01247, number);

CREATE TABLE dist_01247 AS data_01247
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), dist_layer_01247, number);

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
ORDER BY number ASC
LIMIT 1
SETTINGS prefer_localhost_replica = '1';

-- Now, sharding key optimization is not supported for distributed over distributed with serialized plan.
SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
ORDER BY number ASC
LIMIT 1
SETTINGS
    prefer_localhost_replica = '0',
    serialize_query_plan = '1',
    enable_analyzer = '1';

CREATE TABLE dist_01247 AS data_01247
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), dist_layer_01247, rand());

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
ORDER BY number ASC
LIMIT 1;

CREATE TABLE dist_layer_01247 AS data_01247
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01247, rand());

DROP TABLE dist_01247;

DROP TABLE dist_layer_01247;

DROP TABLE data_01247;