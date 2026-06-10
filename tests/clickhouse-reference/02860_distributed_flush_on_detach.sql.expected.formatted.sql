SET prefer_localhost_replica = '0';

DROP TABLE IF EXISTS data;

DROP TABLE IF EXISTS dist;

-- { echoOn }
CREATE TABLE data
(
    key Int
)
ENGINE = Memory();

CREATE TABLE dist
(
    key Int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), data);

SYSTEM STOP DISTRIBUTED SENDS dist;

-- check that FLUSH DISTRIBUTED does flushing anyway
INSERT INTO dist;

SELECT *
FROM data;

SYSTEM FLUSH DISTRIBUTED dist;

TRUNCATE TABLE data;

DETACH TABLE dist;

ATTACH TABLE dist;

-- check flush_on_detach=0
DROP TABLE dist;

CREATE TABLE dist
(
    key Int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), data)
SETTINGS flush_on_detach = '0';