-- Tags: no-parallel
-- no-parallel: it checks the number of threads, which can be lowered in presence of other queries
-- https://github.com/ClickHouse/ClickHouse/issues/37900
DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS t_mv;

CREATE TABLE t
(
    a UInt64
)
ENGINE = Null();

CREATE MATERIALIZED VIEW t_mv
ENGINE = Null()
AS
SELECT
    now() AS ts,
    max(a)
FROM t
GROUP BY ts;

INSERT INTO t SELECT *
FROM numbers_mt(10000000.)
SETTINGS
    max_threads = '10',
    max_insert_threads = '10',
    max_block_size = '100000',
    parallel_view_processing = '1',
    use_concurrency_control = '0';

SYSTEM FLUSH LOGS query_log;

SELECT peak_threads_usage >= 10
FROM `system`.query_log
WHERE event_date >= yesterday()
    AND current_database = currentDatabase()
    AND type = 'QueryFinish'
    AND startsWith(query, 'insert');