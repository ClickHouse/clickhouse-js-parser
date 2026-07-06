-- Tags: no-tsan, no-asan, no-msan, no-ubsan, no-sanitize-coverage, no-parallel-replicas
-- no sanitizers -- memory consumption is unpredicatable with sanitizers
DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    s String,
    n UInt8
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t SELECT
    repeat('x', 100) AS s,
    number
FROM numbers_mt(300000.);

SET max_result_rows = '0', max_result_bytes = '0', max_block_size = '65409', max_threads = '32', join_algorithm = 'parallel_hash';

SET max_memory_usage = '5Gi'; -- on my machine with max_joined_block_size_rows=65K I see consumption of ~1G,

-- without this limit (i.e. max_joined_block_size_rows=0) consumption is ~8-10G
SELECT *
FROM
    t AS t1
INNER JOIN t AS t2
    ON t1.n = t2.n
FORMAT Null
SETTINGS max_joined_block_size_rows = '65409';