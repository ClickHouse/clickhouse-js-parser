DROP TABLE IF EXISTS data_01801;

CREATE TABLE data_01801
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS index_granularity = '10' AS
SELECT number / 10
FROM numbers(100);

-- Prevent remote replicas from skipping index analysis in Parallel Replicas. Otherwise, they may return full ranges and trigger max_rows_to_read validation failures.
SET parallel_replicas_index_analysis_only_on_coordinator = '0';

SELECT *
FROM data_01801
WHERE key = 0
ORDER BY key ASC
SETTINGS max_rows_to_read = '9'
FORMAT Null; -- { serverError TOO_MANY_ROWS }

SELECT *
FROM data_01801
WHERE key = 0
ORDER BY key DESC
SETTINGS max_rows_to_read = '9'
FORMAT Null; -- { serverError TOO_MANY_ROWS }

SELECT *
FROM data_01801
WHERE key = 0
ORDER BY key ASC
SETTINGS max_rows_to_read = '10'
FORMAT Null;

SELECT *
FROM data_01801
WHERE key = 0
ORDER BY key DESC
SETTINGS max_rows_to_read = '10'
FORMAT Null;

DROP TABLE data_01801;