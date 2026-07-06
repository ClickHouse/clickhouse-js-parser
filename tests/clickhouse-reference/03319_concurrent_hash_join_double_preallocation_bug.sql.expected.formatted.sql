-- Tags: no-tsan, no-asan, no-msan, no-ubsan, no-parallel-replicas
DROP TABLE IF EXISTS lhs;

DROP TABLE IF EXISTS rhs;

CREATE TABLE lhs
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE rhs
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO lhs SELECT
    number,
    number
FROM numbers_mt(200000.);

-- rhs should be bigger to trigger tables swap (see `query_plan_join_swap_table`)
INSERT INTO rhs SELECT
    number,
    number
FROM numbers_mt(1000000.);

SET max_threads = '8', query_plan_join_swap_table = '1', join_algorithm = 'parallel_hash', enable_analyzer = '1';

-- First populate the cache of hash table sizes
SELECT *
FROM
    lhs AS t1
INNER JOIN rhs AS t2
    ON t1.a = t2.a
FORMAT Null;

-- For the next run we will preallocate the space
SELECT *
FROM
    lhs AS t1
INNER JOIN rhs AS t2
    ON t1.a = t2.a
FORMAT Null
SETTINGS log_comment = '03319_second_query';

SYSTEM FLUSH LOGS query_log;

SELECT ProfileEvents['HashJoinPreallocatedElementsInHashTables']
FROM `system`.query_log
WHERE event_date >= yesterday()
    AND current_database = currentDatabase()
    AND type = 'QueryFinish'
    AND log_comment = '03319_second_query';