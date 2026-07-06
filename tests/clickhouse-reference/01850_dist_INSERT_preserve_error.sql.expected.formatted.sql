-- Tags: no-parallel
CREATE DATABASE IF NOT EXISTS shard_0;

CREATE DATABASE IF NOT EXISTS shard_1;

DROP TABLE IF EXISTS dist_01850;

DROP TABLE IF EXISTS shard_0.data_01850;

CREATE TABLE shard_0.data_01850
(
    key Int
)
ENGINE = Memory();

CREATE TABLE dist_01850
(
    key Int
)
ENGINE = Distributed('test_cluster_two_replicas_different_databases', '', data_01850, key);

SET distributed_foreground_insert = '1';

SET prefer_localhost_replica = '0';

INSERT INTO dist_01850; -- { serverError UNKNOWN_TABLE }

DROP TABLE shard_0.data_01850;

DROP DATABASE shard_0;

DROP DATABASE shard_1;