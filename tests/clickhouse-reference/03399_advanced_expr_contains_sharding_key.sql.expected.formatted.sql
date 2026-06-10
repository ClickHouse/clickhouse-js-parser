DROP TABLE IF EXISTS local_table;

DROP TABLE IF EXISTS distributed_table;

DROP TABLE IF EXISTS distributed_table2;

SET optimize_skip_unused_shards = true;

SET prefer_localhost_replica = '0';

SET allow_experimental_analyzer = '1';

CREATE TABLE local_table
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE distributed_table AS local_table
ENGINE = Distributed(test_cluster_two_shard_three_replicas_localhost, currentDatabase(), local_table, id);

CREATE TABLE distributed_table2 AS local_table
ENGINE = Distributed(test_cluster_two_shard_three_replicas_localhost, currentDatabase(), local_table);

INSERT INTO local_table SELECT number
FROM numbers(100);

EXPLAIN
SELECT count()
FROM distributed_table
GROUP BY id;

EXPLAIN
SELECT count()
FROM distributed_table2
GROUP BY id;

EXPLAIN
SELECT count()
FROM distributed_table
GROUP BY toString(id);

EXPLAIN
SELECT count()
FROM distributed_table2
GROUP BY toString(id);

EXPLAIN
SELECT DISTINCT id
FROM distributed_table;

EXPLAIN
SELECT DISTINCT id
FROM distributed_table2;

EXPLAIN
SELECT DISTINCT toString(id)
FROM distributed_table;

EXPLAIN
SELECT DISTINCT toString(id)
FROM distributed_table2;

EXPLAIN
SELECT *
FROM distributed_table
LIMIT 1 BY id;

EXPLAIN
SELECT *
FROM distributed_table2
LIMIT 1 BY id;

EXPLAIN
SELECT *
FROM distributed_table
LIMIT 1 BY toString(id);

EXPLAIN
SELECT *
FROM distributed_table2
LIMIT 1 BY toString(id);