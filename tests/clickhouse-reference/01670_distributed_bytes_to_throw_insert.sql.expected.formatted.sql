-- Tags: distributed
DROP TABLE IF EXISTS dist_01670;

DROP TABLE IF EXISTS data_01670;

CREATE TABLE data_01670
(
    key Int
)
ENGINE = Null();

CREATE TABLE dist_01670
(
    key Int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), data_01670)
SETTINGS bytes_to_throw_insert = '1';

SYSTEM STOP DISTRIBUTED SENDS dist_01670;

-- first batch is always OK, since there is no pending bytes yet
INSERT INTO dist_01670 SELECT *
FROM numbers(1)
SETTINGS prefer_localhost_replica = '0';

SYSTEM FLUSH DISTRIBUTED dist_01670;

DROP TABLE dist_01670;

DROP TABLE data_01670;