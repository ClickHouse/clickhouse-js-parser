DROP TABLE IF EXISTS merge_dist_01223;

DROP TABLE IF EXISTS dist_01223;

DROP TABLE IF EXISTS dist_layer_01223;

DROP TABLE IF EXISTS data_01223;

CREATE TABLE data_01223
(
    key Int
)
ENGINE = Memory();

CREATE TABLE dist_layer_01223 AS data_01223
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01223);

CREATE TABLE dist_01223 AS data_01223
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), dist_layer_01223);

SELECT *
FROM dist_01223;

INSERT INTO data_01223 SELECT *
FROM numbers(3);

SELECT DISTINCT *
FROM dist_01223
ORDER BY key ASC;

SELECT *
FROM dist_01223
GROUP BY key
ORDER BY key ASC;

SELECT *
FROM dist_01223
GROUP BY key
ORDER BY key ASC
LIMIT 1;

SELECT *
FROM dist_01223
HAVING key = 1;

SELECT *
FROM dist_01223
GROUP BY key
HAVING key = 1;

SELECT *
FROM dist_01223
ORDER BY key ASC;

SELECT *
FROM dist_01223
ORDER BY key ASC
LIMIT 1;

SELECT *
FROM dist_01223
ORDER BY key ASC
LIMIT 1 BY key;

SELECT *
FROM cluster(test_cluster_two_shards, currentDatabase(), dist_01223)
ORDER BY key ASC;

SELECT *
FROM cluster(test_cluster_two_shards, currentDatabase(), dist_01223)
GROUP BY key
ORDER BY key ASC;

SELECT
    a.key,
    b.key
FROM
    (
        SELECT toInt32(number) AS key
        FROM numbers(2)
    ) AS a
LEFT JOIN (
        SELECT DISTINCT *
        FROM dist_01223
    ) AS b
    USING (key)
ORDER BY b.key ASC;

SELECT
    a.key,
    b.key
FROM
    (
        SELECT toInt32(number) AS key
        FROM numbers(2)
    ) AS a
RIGHT JOIN (
        SELECT DISTINCT *
        FROM dist_01223
    ) AS b
    USING (key)
ORDER BY b.key ASC;

-- more data for GROUP BY
INSERT INTO data_01223 SELECT number % 3
FROM numbers(30);

SELECT *
FROM dist_01223
GROUP BY key
ORDER BY key ASC
SETTINGS
    group_by_two_level_threshold = '1',
    group_by_two_level_threshold_bytes = '1';

SELECT *
FROM dist_01223
GROUP BY key
ORDER BY key ASC
SETTINGS distributed_aggregation_memory_efficient = '1';

SELECT *
FROM dist_01223
GROUP BY key
ORDER BY key ASC
SETTINGS
    group_by_two_level_threshold = '1',
    group_by_two_level_threshold_bytes = '1',
    distributed_aggregation_memory_efficient = '1';

SELECT count()
FROM dist_01223;

SELECT count()
FROM dist_01223
SETTINGS distributed_group_by_no_merge = '1';

DROP TABLE dist_01223;

DROP TABLE dist_layer_01223;

CREATE TABLE dist_layer_01223 AS data_01223
ENGINE = Distributed(test_shard_localhost, currentDatabase(), data_01223);

CREATE TABLE merge_dist_01223 AS dist_01223
ENGINE = Merge(currentDatabase(), 'dist_01223');

SELECT count()
FROM merge_dist_01223;

SELECT count()
FROM merge_dist_01223
SETTINGS distributed_group_by_no_merge = '1';

SELECT DISTINCT *
FROM dist_01223
WHERE key GLOBAL IN (
        SELECT toInt32(1)
    );

DROP TABLE merge_dist_01223;

DROP TABLE data_01223;