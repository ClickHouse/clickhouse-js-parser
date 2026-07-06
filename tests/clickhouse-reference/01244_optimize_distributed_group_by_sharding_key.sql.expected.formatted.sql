-- Tags: distributed
-- TODO: correct testing with real unique shards
SET optimize_distributed_group_by_sharding_key = '1';

-- Some queries in this test require sorting after aggregation.
SET max_bytes_before_external_group_by = '0';

SET max_bytes_ratio_before_external_group_by = '0';

DROP TABLE IF EXISTS dist_01247;

DROP TABLE IF EXISTS data_01247;

CREATE TABLE data_01247 AS `system`.numbers
ENGINE = Memory();

INSERT INTO data_01247 SELECT *
FROM `system`.numbers
LIMIT 2;

CREATE TABLE dist_01247 AS data_01247
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01247, number);

-- since data is not inserted via distributed it will have duplicates
-- (and this is how we ensure that this optimization will work)
SET max_distributed_connections = '1';

SET prefer_localhost_replica = '0';

SET enable_positional_arguments = '0';

SELECT *
FROM dist_01247;

SET optimize_skip_unused_shards = '1';

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
SETTINGS distributed_group_by_no_merge = '1';

SELECT
    count(),
    *
FROM dist_01247
GROUP BY
    number,
    1;

SELECT
    count(),
    min(number)
FROM dist_01247
GROUP BY 1;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
ORDER BY number DESC;

SELECT
    count(),
    any(number)
FROM dist_01247
GROUP BY toString(number);

SELECT
    count(),
    any(number)
FROM dist_01247
GROUP BY number % 2;

SELECT countDistinct(number)
FROM dist_01247;

SELECT countDistinct(number)
FROM dist_01247
GROUP BY number;

SELECT DISTINCT number
FROM dist_01247;

SELECT
    count() AS cnt,
    *
FROM dist_01247
GROUP BY number
HAVING cnt = 2;

SELECT
    count() AS cnt,
    *
FROM dist_01247
GROUP BY number
HAVING cnt = 1
LIMIT 1;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
LIMIT 1;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
LIMIT 1
OFFSET 1;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
OFFSET 1
SETTINGS distributed_push_down_limit = '0';

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
ORDER BY
    count() ASC,
    number ASC
OFFSET 1
SETTINGS distributed_push_down_limit = '1';

SELECT
    count(),
    *
FROM dist_01247
WHERE number = _shard_num - 1
GROUP BY number
ORDER BY number ASC
LIMIT 1
OFFSET 1;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
ORDER BY number ASC
LIMIT 1 BY number;

SELECT
    count(),
    *
FROM cluster(test_cluster_two_shards, currentDatabase(), dist_01247)
GROUP BY number
ORDER BY number ASC;

SELECT
    count(),
    *
FROM cluster(test_cluster_two_shards, currentDatabase(), dist_01247)
GROUP BY number
ORDER BY number ASC
SETTINGS distributed_group_by_no_merge = '1';

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
SETTINGS extremes = '1';

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
LIMIT 1
SETTINGS extremes = '1';

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
WITH TOTALS;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
WITH ROLLUP;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
WITH CUBE;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
WITH TOTALS
ORDER BY number ASC;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
WITH TOTALS
ORDER BY number ASC
LIMIT 1;

SELECT
    count(),
    *
FROM dist_01247
GROUP BY number
WITH TOTALS
LIMIT 1;

CREATE TABLE data_01247
ENGINE = Memory() AS
SELECT
    number AS key,
    0 AS value
FROM numbers(2);

CREATE TABLE dist_01247 AS data_01247
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), data_01247, key);

SELECT *
FROM dist_01247
GROUP BY
    key,
    value;

SELECT *
FROM dist_01247
GROUP BY
    value,
    key;

SELECT
    k1,
    k2,
    sum(v)
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v), cityHash64(k1, k2))
GROUP BY
    k1,
    k2; -- optimization applied

SELECT
    k1,
    any(k2),
    sum(v)
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v), cityHash64(k1, k2))
GROUP BY k1; -- optimization does not applied

SELECT DISTINCT
    k1,
    k2
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v), cityHash64(k1, k2)); -- optimization applied

SELECT k2
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v), cityHash64(k1, k2))
LIMIT 1 BY k1; -- optimization does not applied

SELECT
    key,
    sum(sum(value)) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM dist_01247
GROUP BY key;

DROP TABLE dist_01247;

DROP TABLE data_01247;