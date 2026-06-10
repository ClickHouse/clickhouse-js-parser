SET enable_analyzer = '1';

DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Nullable(Int)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test_03634_{database}/t0', 'r1')
ORDER BY tuple();

INSERT INTO t0 (c0);

SELECT tx.c0.`null`
FROM
    t0 AS tx
GLOBAL RIGHT JOIN t0 AS ty
    ON tx.c0 = ty.c0
SETTINGS
    allow_experimental_parallel_reading_from_replicas = '1',
    cluster_for_parallel_replicas = 'test_cluster_one_shard_two_replicas',
    max_parallel_replicas = '10';

DROP TABLE t0;