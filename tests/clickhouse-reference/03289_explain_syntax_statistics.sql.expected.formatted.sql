CREATE TABLE data_01247 AS `system`.numbers
ENGINE = Memory();

INSERT INTO data_01247 SELECT *
FROM `system`.numbers
LIMIT 2;

CREATE TABLE dist_01247 AS data_01247
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01247, number);

SET use_statistics = '1';

EXPLAIN SYNTAX
SELECT
    'Get hierarchy',
    toNullable(13),
    count() IGNORE NULLS
FROM dist_01247
GROUP BY number
WITH CUBE
SETTINGS distributed_group_by_no_merge = '3'
FORMAT Null;