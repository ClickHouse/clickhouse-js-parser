-- Tags: distributed, no-parallel
DROP DATABASE IF EXISTS shard_0;

DROP DATABASE IF EXISTS shard_1;

DROP TABLE IF EXISTS t_distr;

CREATE DATABASE IF NOT EXISTS shard_0;

CREATE DATABASE IF NOT EXISTS shard_1;

CREATE TABLE shard_0.t_local
(
    a Int
)
ENGINE = Memory();

CREATE TABLE shard_1.t_local
(
    a Int
)
ENGINE = Memory();

CREATE TABLE t_distr
(
    a Int
)
ENGINE = Distributed(test_cluster_two_shards_different_databases, '', 't_local', 1000);

SET distributed_foreground_insert = '0';

INSERT INTO t_distr;

SET distributed_foreground_insert = '1';

INSERT INTO t_distr;

SYSTEM FLUSH DISTRIBUTED t_distr;

SELECT *
FROM t_distr
ORDER BY a ASC;

DROP TABLE t_distr;

DROP DATABASE shard_0;

DROP DATABASE shard_1;