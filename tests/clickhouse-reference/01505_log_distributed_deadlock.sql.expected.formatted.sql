-- Tags: deadlock, distributed
DROP TABLE IF EXISTS t_local;

DROP TABLE IF EXISTS t_dist;

CREATE TABLE t_local
(
    a int
)
ENGINE = Log();

CREATE TABLE t_dist
(
    a int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 't_local', cityHash64(a));

SET distributed_foreground_insert = '1';

INSERT INTO t_dist;

DROP TABLE t_local;

DROP TABLE t_dist;