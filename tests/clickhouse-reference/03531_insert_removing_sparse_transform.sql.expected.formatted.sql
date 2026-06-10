-- Tags: no-asan, no-tsan, no-msan, no-ubsan, no-sanitize-coverage, no-parallel-replicas, no-flaky-check
-- - no-parallel-replicas - has --replace-log-memory-with-mergetree switch
DROP TABLE IF EXISTS t_log;

DROP TABLE IF EXISTS t_mt;

DROP TABLE IF EXISTS mv;

SET max_threads = '1';

SET max_insert_threads = '1';

SET deduplicate_blocks_in_dependent_materialized_views = '0';

-- { echo }
-- Log does not support sparse columns - RemovingSparseTransform added
CREATE TABLE t_log
(
    key Int
)
ENGINE = Log();

EXPLAIN PIPELINE
INSERT INTO t_log SELECT *
FROM `system`.one;

-- MergeTree support sparse columns - no RemovingSparseTransform
CREATE TABLE t_mt
(
    key Int
)
ENGINE = MergeTree()
ORDER BY ();

EXPLAIN PIPELINE
INSERT INTO t_mt SELECT *
FROM `system`.one;

-- MergeTree pushes to Log, which does not support sparse columns - RemovingSparseTransform added
CREATE MATERIALIZED VIEW mv
TO t_log
AS
SELECT *
FROM t_mt;

DROP TABLE mv;

-- Log does not support sparse columns - RemovingSparseTransform added
CREATE MATERIALIZED VIEW mv
TO t_mt
AS
SELECT *
FROM t_log;