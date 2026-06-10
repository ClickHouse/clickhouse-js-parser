-- Tags: no-replicated-database
-- Tag no-replicated-database: ON CLUSTER is not allowed
DROP TABLE IF EXISTS local_t_l5ydey;

CREATE TABLE local_t_l5ydey ON CLUSTER test_shard_localhost
(
    c_qv5rv INTEGER,
    c_rutjs4 INTEGER,
    c_wmj INTEGER,
    c_m3 TEXT NOT NULL,
    PRIMARY KEY(c_qv5rv)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test_' || currentDatabase() || '/{shard}/local_t_l5ydey', '{replica}');

CREATE TABLE t_l5ydey ON CLUSTER test_shard_localhost AS local_t_l5ydey
ENGINE = Distributed('test_shard_localhost', currentDatabase(), 'local_t_l5ydey', rand());

INSERT INTO local_t_l5ydey;

INSERT INTO t_l5ydey;

SYSTEM FLUSH DISTRIBUTED t_l5ydey;

SELECT *
FROM t_l5ydey
ORDER BY c_qv5rv ASC;

SHOW CREATE TABLE t_l5ydey;

-- Correct error code if creating database with the same path as table has
CREATE DATABASE local_t_l5ydey
ENGINE = Replicated('/clickhouse/tables/test_' || currentDatabase() || '/{shard}/local_t_l5ydey', '1', '1'); -- { serverError BAD_ARGUMENTS }

DROP TABLE local_t_l5ydey;