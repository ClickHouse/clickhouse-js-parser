DROP TABLE IF EXISTS t_rio;

SET optimize_read_in_order = '1';

SET enable_parallel_replicas = '1', max_parallel_replicas = '3', cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost', parallel_replicas_for_non_replicated_merge_tree = '1', parallel_replicas_local_plan = '1';

CREATE TABLE t_rio
(
    a int,
    b int,
    c int
)
ENGINE = MergeTree()
ORDER BY (a, b);

INSERT INTO t_rio SELECT
    number % number,
    number % 5,
    number % 10
FROM numbers(1, 1000000);

SELECT
    a,
    b,
    x,
    y
FROM (
        SELECT
            a,
            b,
            1 AS x,
            2 AS y
        FROM t_rio
        ORDER BY a ASC
    )
ORDER BY
    a ASC,
    b ASC
FORMAT Null;