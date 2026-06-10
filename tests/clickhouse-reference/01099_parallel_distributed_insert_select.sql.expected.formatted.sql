-- Tags: distributed
-- <Warning> ConnectionPoolWithFailover: Connection failed at try №1 - is not a problem
SET send_logs_level = 'fatal';

SET prefer_localhost_replica = '1';

DROP TABLE IF EXISTS local_01099_a;

DROP TABLE IF EXISTS local_01099_b;

DROP TABLE IF EXISTS distributed_01099_a;

DROP TABLE IF EXISTS distributed_01099_b;

SET parallel_distributed_insert_select = '1';

CREATE TABLE local_01099_a
(
    number UInt64
)
ENGINE = Log();

CREATE TABLE local_01099_b
(
    number UInt64
)
ENGINE = Log();

CREATE TABLE distributed_01099_a AS local_01099_a
ENGINE = Distributed('test_shard_localhost', currentDatabase(), local_01099_a, rand());

CREATE TABLE distributed_01099_b AS local_01099_b
ENGINE = Distributed('test_shard_localhost', currentDatabase(), local_01099_b, rand());

INSERT INTO local_01099_a SELECT number
FROM `system`.numbers
LIMIT 3;

INSERT INTO distributed_01099_b SELECT *
FROM distributed_01099_a;

SELECT *
FROM distributed_01099_b;

DROP TABLE local_01099_a;

DROP TABLE local_01099_b;

DROP TABLE distributed_01099_a;

DROP TABLE distributed_01099_b;

CREATE TABLE distributed_01099_a AS local_01099_a
ENGINE = Distributed('test_cluster_two_shards_localhost', currentDatabase(), local_01099_a, rand());

CREATE TABLE distributed_01099_b AS local_01099_b
ENGINE = Distributed('test_cluster_two_shards_localhost', currentDatabase(), local_01099_b, rand());

SELECT
    number,
    count(number)
FROM local_01099_b
GROUP BY number
ORDER BY number ASC;

CREATE TABLE distributed_01099_a AS local_01099_a
ENGINE = Distributed('test_cluster_two_shards', currentDatabase(), local_01099_a, rand());

CREATE TABLE distributed_01099_b AS local_01099_b
ENGINE = Distributed('test_cluster_two_shards', currentDatabase(), local_01099_b, rand());

SYSTEM STOP DISTRIBUTED SENDS distributed_01099_b;

SET prefer_localhost_replica = '0'; -- to require distributed send for local replica too

SET prefer_localhost_replica = '1';

SELECT
    number,
    count(number)
FROM distributed_01099_b
GROUP BY number
ORDER BY number ASC;

SYSTEM FLUSH DISTRIBUTED distributed_01099_b;

CREATE TABLE local_01099_a
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY number;

CREATE TABLE local_01099_b
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY number;

CREATE TABLE distributed_01099_a AS local_01099_a
ENGINE = Distributed('test_cluster_1_shard_3_replicas_1_unavailable', currentDatabase(), local_01099_a, rand());

CREATE TABLE distributed_01099_b AS local_01099_b
ENGINE = Distributed('test_cluster_1_shard_3_replicas_1_unavailable', currentDatabase(), local_01099_b, rand());

SET send_logs_level = 'fatal';

SET send_logs_level = 'warning';

SET send_logs_level = 'error';

INSERT INTO distributed_01099_b SELECT *
FROM urlCluster('test_cluster_two_shards', 'http://localhost:8123/?query=select+{1,2,3}+format+TSV', 'TSV', 's String');

SET parallel_distributed_insert_select = '2';

--- https://github.com/ClickHouse/ClickHouse/issues/78464
CREATE TABLE local_01099_c
(
    n UInt64
)
ENGINE = Log();

CREATE TABLE distributed_01099_c AS local_01099_c
ENGINE = Distributed('test_shard_localhost', currentDatabase(), local_01099_c, rand());

INSERT INTO FUNCTION clusterAllReplicas('test_shard_localhost', currentDatabase(), 'distributed_01099_c') (n) SELECT number
FROM remote('localhost', numbers(5)) AS tx;

SELECT *
FROM distributed_01099_c;

DROP TABLE local_01099_c;

DROP TABLE distributed_01099_c;

TRUNCATE TABLE local_01099_b;

INSERT INTO distributed_01099_b WITH 'http://localhost:8123/?query=' || 'select+{1,2,3}+format+TSV' AS url

SELECT *
FROM urlCluster('test_cluster_two_shards', (
        SELECT url
    ), 'TSV', 's String');