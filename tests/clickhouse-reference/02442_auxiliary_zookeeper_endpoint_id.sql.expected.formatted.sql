-- Tags: no-fasttest, no-shared-merge-tree
-- no-shared-merge-tree -- shared merge tree doesn't support aux zookeepers
DROP TABLE IF EXISTS t1_r1 SYNC;

DROP TABLE IF EXISTS t1_r2 SYNC;

DROP TABLE IF EXISTS t2 SYNC;

CREATE TABLE t1_r1
(
    x Int32
)
ENGINE = ReplicatedMergeTree('/test/02442/{database}/t', 'r1')
ORDER BY x;

CREATE TABLE t1_r2
(
    x Int32
)
ENGINE = ReplicatedMergeTree('/test/02442/{database}/t', 'r2')
ORDER BY x;

-- create table with same replica_path as t1_r1
CREATE TABLE t2
(
    x Int32
)
ENGINE = ReplicatedMergeTree('zookeeper2:/test/02442/{database}/t', 'r1')
ORDER BY x;

DROP TABLE t2 SYNC;

-- insert data into one replica
INSERT INTO t1_r1 SELECT *
FROM generateRandom('x Int32')
LIMIT 10013;

SYSTEM SYNC REPLICA t1_r2;

SELECT count()
FROM t1_r2;

DROP TABLE t1_r1 SYNC;

DROP TABLE t1_r2 SYNC;