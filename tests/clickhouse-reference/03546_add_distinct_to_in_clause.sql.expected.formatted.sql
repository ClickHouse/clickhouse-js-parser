-- Tags: shard, no-parallel
DROP TABLE IF EXISTS local_table_1;

DROP TABLE IF EXISTS local_table_2;

DROP TABLE IF EXISTS distributed_table_1;

DROP TABLE IF EXISTS distributed_table_2;

SET prefer_localhost_replica = '0';

SET allow_experimental_analyzer = '1';

SET distributed_product_mode = 'allow';

SET prefer_global_in_and_join = '1';

SET max_rows_to_read = '100000000';

SET read_overflow_mode = 'break';

CREATE TABLE local_table_1
(
    id int
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE local_table_2
(
    id int
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE distributed_table_1
(
    id int
)
ENGINE = Distributed(test_cluster_two_shard_three_replicas_localhost, currentDatabase(), local_table_1);

CREATE TABLE distributed_table_2
(
    id int
)
ENGINE = Distributed(test_cluster_two_shard_three_replicas_localhost, currentDatabase(), local_table_2);

INSERT INTO local_table_1 SELECT number
FROM numbers(100);

INSERT INTO local_table_2 SELECT 1
FROM numbers(1000000);

INSERT INTO local_table_2 SELECT 2
FROM numbers(1000000);

INSERT INTO local_table_2 SELECT 3
FROM numbers(1000000);

SELECT id
FROM distributed_table_1
WHERE id IN (
        SELECT id
        FROM distributed_table_2
    )
SETTINGS enable_add_distinct_to_in_subqueries = '1';

-- Query with DISTINCT optimization disabled
SELECT id
FROM distributed_table_1
WHERE id IN (
        SELECT id
        FROM distributed_table_2
    )
SETTINGS enable_add_distinct_to_in_subqueries = '0';

SYSTEM FLUSH LOGS query_log;

-- Compare both NetworkReceiveBytes between with_distinct and without_distinct
-- Get the value for with_distinct
WITH (
      SELECT
          read_rows,
          ProfileEvents
      FROM `system`.query_log
      WHERE current_database = currentDatabase()
          AND query LIKE '%select id from distributed_table_1 where id in (select id from distributed_table_2) settings enable_add_distinct_to_in_subqueries = 1%'
          AND type = 'QueryFinish'
          AND is_initial_query
      ORDER BY event_time DESC
      LIMIT 1
  ) AS q1,

  -- Get the value for without_distinct
  (
      SELECT
          read_rows,
          ProfileEvents
      FROM `system`.query_log
      WHERE current_database = currentDatabase()
          AND query LIKE '%select id from distributed_table_1 where id in (select id from distributed_table_2) settings enable_add_distinct_to_in_subqueries = 0%'
          AND type = 'QueryFinish'
          AND is_initial_query
      ORDER BY event_time DESC
      LIMIT 1
  ) AS q2

SELECT
    q1.read_rows < q2.read_rows AS read_rows_optimization_effective,
    q1.ProfileEvents['NetworkSendBytes'] < q2.ProfileEvents['NetworkSendBytes'] AS send_optimization_effective,
    q1.ProfileEvents['NetworkReceiveBytes'] < q2.ProfileEvents['NetworkReceiveBytes'] AS recv_optimization_effective;