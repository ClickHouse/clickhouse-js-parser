-- Tags: no-random-settings
SET enable_analyzer = '1';

SET serialize_query_plan = '0';

EXPLAIN actions = '1', distributed = '1'
SELECT sum(number)
FROM remote('127.0.0.{1,2,3}', numbers(5))
GROUP BY bitAnd(number, 3);

EXPLAIN distributed = '1'
SELECT *
FROM (
        SELECT *
        FROM remote('127.0.0.{1,2}', numbers(2))
        WHERE number = 1
    );

SELECT '----------';

SET serialize_query_plan = '1';

DROP TABLE IF EXISTS test_parallel_replicas;

CREATE TABLE test_parallel_replicas
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_parallel_replicas SELECT *
FROM numbers(10);

SET enable_parallel_replicas = '2', max_parallel_replicas = '2', cluster_for_parallel_replicas = 'test_cluster_one_shard_two_replicas', parallel_replicas_for_non_replicated_merge_tree = '1', parallel_replicas_local_plan = '1';

EXPLAIN actions = '1', distributed = '1'
SELECT sum(number)
FROM test_parallel_replicas
GROUP BY bitAnd(number, 3);