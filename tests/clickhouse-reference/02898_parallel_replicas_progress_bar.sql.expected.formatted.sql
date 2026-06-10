DROP TABLE IF EXISTS t1 SYNC;

DROP TABLE IF EXISTS t2 SYNC;

DROP TABLE IF EXISTS t3 SYNC;

CREATE TABLE t1
(
    k UInt32,
    v String
)
ENGINE = ReplicatedMergeTree('/02898_parallel_replicas/{database}/test_tbl', 'r1')
ORDER BY k;

CREATE TABLE t2
(
    k UInt32,
    v String
)
ENGINE = ReplicatedMergeTree('/02898_parallel_replicas/{database}/test_tbl', 'r2')
ORDER BY k;

CREATE TABLE t3
(
    k UInt32,
    v String
)
ENGINE = ReplicatedMergeTree('/02898_parallel_replicas/{database}/test_tbl', 'r3')
ORDER BY k;

INSERT INTO t1 SELECT
    number,
    toString(number)
FROM numbers(1000, 1000);

INSERT INTO t2 SELECT
    number,
    toString(number)
FROM numbers(2000, 1000);

INSERT INTO t3 SELECT
    number,
    toString(number)
FROM numbers(3000, 1000);

SYSTEM SYNC REPLICA t1;

SYSTEM SYNC REPLICA t2;

SYSTEM SYNC REPLICA t3;

SET enable_parallel_replicas = '1', max_parallel_replicas = '3', cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost';

SET parallel_replicas_local_plan = '0'; -- corresponding logs about total rows are written only during interaction with remote nodes

-- but with local plan a query execution can be finished locally even before we get response from remote node
SET parallel_replicas_only_with_analyzer = '0'; -- necessary for CI run with disabled analyzer

SET parallel_replicas_for_non_replicated_merge_tree = '0'; -- To avoid https://github.com/ClickHouse/ClickHouse/issues/93193

-- default coordinator
SELECT
    count(),
    min(k),
    max(k),
    avg(k)
FROM t1
SETTINGS log_comment = '02898_default_190aed82-2423-413b-ad4c-24dcca50f65b';

-- check logs
SYSTEM FLUSH LOGS text_log, query_log;

SET max_rows_to_read = '0'; -- system.text_log can be really big

SELECT count() > 0
FROM `system`.text_log
WHERE query_id IN (
        SELECT query_id
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
            AND log_comment = '02898_default_190aed82-2423-413b-ad4c-24dcca50f65b'
            AND event_date >= yesterday()
    )
    AND message LIKE '%Total rows to read: 3000%'
    AND event_date >= yesterday();

-- reading in order coordinator
-- disable parallel_replicas_local_plan since the test relay on traces which only present in case of no local plan
SELECT
    k,
    sipHash64(v)
FROM t1
ORDER BY k ASC
LIMIT 5
OFFSET 998
SETTINGS
    optimize_read_in_order = '1',
    log_comment = '02898_inorder_190aed82-2423-413b-ad4c-24dcca50f65b';

SELECT count() > 0
FROM `system`.text_log
WHERE query_id IN (
        SELECT query_id
        FROM `system`.query_log
        WHERE current_database = currentDatabase()
            AND log_comment = '02898_inorder_190aed82-2423-413b-ad4c-24dcca50f65b'
            AND event_date >= yesterday()
    )
    AND message LIKE '%Updated total rows to read: added % rows, total 3000 rows%'
    AND event_date >= yesterday();

DROP TABLE t1 SYNC;

DROP TABLE t2 SYNC;

DROP TABLE t3 SYNC;