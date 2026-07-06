-- Tags: distributed
DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS d;

CREATE TABLE t
(
    x Enum8('abc' = 0, 'def' = 1, 'ghi' = 2)
)
ENGINE = TinyLog();

INSERT INTO t;

SELECT *
FROM t;

SELECT '---';

CREATE TABLE d
(
    x Enum8('abc' = 0, 'def' = 1, 'xyz' = 2)
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), t);

SELECT *
FROM d;

DROP TABLE d;

CREATE TABLE d
(
    x Enum8('abc' = 0, 'def' = 1, 'xyz' = 2)
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), t);

CREATE TABLE d
(
    x Enum8('abc' = 0, 'def' = 1, 'xyz' = 2)
)
ENGINE = Distributed(test_cluster_two_shards_localhost, currentDatabase(), t);

DROP TABLE t;