-- Tags: shard
DROP TABLE IF EXISTS local_02175;

DROP TABLE IF EXISTS dist_02175;

CREATE TABLE local_02175
ENGINE = Memory() AS
SELECT *
FROM `system`.one;

CREATE TABLE dist_02175 AS local_02175
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), local_02175);

-- { echoOn }
SELECT *
FROM
    dist_02175 AS l
INNER JOIN local_02175 AS r
    USING (dummy);

SELECT *
FROM
    dist_02175 AS l
GLOBAL INNER JOIN local_02175 AS r
    USING (dummy);

-- explicit database for distributed table
SELECT *
FROM
    remote('127.1', currentDatabase(), dist_02175) AS l
INNER JOIN local_02175 AS r
    USING (dummy);

SELECT *
FROM
    remote('127.1', currentDatabase(), dist_02175) AS l
GLOBAL INNER JOIN local_02175 AS r
    USING (dummy);

-- { echoOff }
DROP TABLE local_02175;

DROP TABLE dist_02175;