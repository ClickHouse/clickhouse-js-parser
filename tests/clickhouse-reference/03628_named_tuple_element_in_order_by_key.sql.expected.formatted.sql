DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x Tuple(a UInt64, b String)
)
ENGINE = MergeTree()
ORDER BY x.b
SETTINGS index_granularity = '1';

INSERT INTO test;

SELECT *
FROM test
ORDER BY x ASC;

SELECT *
FROM test
ORDER BY x.a ASC;

SELECT *
FROM test
ORDER BY x.b ASC;

SELECT *
FROM test
WHERE x.a = 2;

-- Set `parallel_replicas_index_analysis_only_on_coordinator = 0` to prevent remote replicas from skipping index analysis in Parallel Replicas.
-- Otherwise, they may return full ranges and trigger max_rows_to_read validation failures.
SELECT *
FROM test
WHERE x.b = 'World'
SETTINGS
    max_rows_to_read = '1',
    parallel_replicas_index_analysis_only_on_coordinator = '0';

SELECT x.a
FROM test
ORDER BY x ASC;

SELECT x.a
FROM test
ORDER BY x.a ASC;

SELECT x.a
FROM test
ORDER BY x.b ASC;

SELECT x.a
FROM test
WHERE x.a = 2;

SELECT x.a
FROM test
WHERE x.b = 'World'
SETTINGS
    max_rows_to_read = '1',
    parallel_replicas_index_analysis_only_on_coordinator = '0';

SELECT x.b
FROM test
ORDER BY x ASC;

SELECT x.b
FROM test
ORDER BY x.a ASC;

SELECT x.b
FROM test
ORDER BY x.b ASC;

SELECT x.b
FROM test
WHERE x.a = 2;

SELECT x.b
FROM test
WHERE x.b = 'World'
SETTINGS
    max_rows_to_read = '1',
    parallel_replicas_index_analysis_only_on_coordinator = '0';

DROP TABLE test;