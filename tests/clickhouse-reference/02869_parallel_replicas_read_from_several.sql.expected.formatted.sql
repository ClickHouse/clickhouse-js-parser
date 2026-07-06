DROP TABLE IF EXISTS t1 SYNC;

DROP TABLE IF EXISTS t2 SYNC;

DROP TABLE IF EXISTS t3 SYNC;

CREATE TABLE t1
(
    k UInt32,
    v UInt32
)
ENGINE = ReplicatedMergeTree('/parallel_replicas/{database}/test_tbl', 'r1')
ORDER BY k
SETTINGS index_granularity = '10';

CREATE TABLE t2
(
    k UInt32,
    v UInt32
)
ENGINE = ReplicatedMergeTree('/parallel_replicas/{database}/test_tbl', 'r2')
ORDER BY k
SETTINGS index_granularity = '10';

CREATE TABLE t3
(
    k UInt32,
    v UInt32
)
ENGINE = ReplicatedMergeTree('/parallel_replicas/{database}/test_tbl', 'r3')
ORDER BY k
SETTINGS index_granularity = '10';

INSERT INTO t1 SELECT
    number,
    number
FROM numbers(1000);

INSERT INTO t1 SELECT
    number,
    number
FROM numbers(1000, 1000);

INSERT INTO t1 SELECT
    number,
    number
FROM numbers(2000, 1000);

INSERT INTO t2 SELECT
    number,
    number
FROM numbers(3000, 1000);

INSERT INTO t2 SELECT
    number,
    number
FROM numbers(4000, 1000);

INSERT INTO t2 SELECT
    number,
    number
FROM numbers(5000, 1000);

INSERT INTO t3 SELECT
    number,
    number
FROM numbers(6000, 1000);

INSERT INTO t3 SELECT
    number,
    number
FROM numbers(7000, 1000);

INSERT INTO t3 SELECT
    number,
    number
FROM numbers(8000, 1000);

SYSTEM SYNC REPLICA t1;

SYSTEM SYNC REPLICA t2;

SYSTEM SYNC REPLICA t3;

SELECT
    count(),
    min(k),
    max(k),
    avg(k)
FROM t1
SETTINGS
    enable_parallel_replicas = '1',
    max_parallel_replicas = '3',
    cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost';