-- Tags: distributed
DROP TABLE IF EXISTS data;

DROP TABLE IF EXISTS dist;

CREATE TABLE data
(
    key String
)
ENGINE = Memory();

CREATE TABLE dist
(
    key LowCardinality(String)
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data);

INSERT INTO data;

SET distributed_aggregation_memory_efficient = '1';

-- There is an obscure bug in rare corner case.
SET max_bytes_before_external_group_by = '0';

SET max_bytes_ratio_before_external_group_by = '0';

SELECT *
FROM dist
GROUP BY key;

DROP TABLE data;

DROP TABLE dist;