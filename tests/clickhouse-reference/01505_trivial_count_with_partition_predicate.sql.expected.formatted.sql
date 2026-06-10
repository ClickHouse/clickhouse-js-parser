-- add_minmax_index_for_numeric_columns=0: Changes how many rows are read
DROP TABLE IF EXISTS test1;

DROP TABLE IF EXISTS test_tuple;

DROP TABLE IF EXISTS test_two_args;

CREATE TABLE test1
(
    p DateTime,
    k int
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toDate(p)
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

INSERT INTO test1;

SET max_rows_to_read = '1';

SET optimize_use_implicit_projections = '1';

-- non-optimized
SELECT count()
FROM test1
SETTINGS max_parallel_replicas = '3';

-- optimized (toYear is monotonic and we provide the partition expr as is)
SELECT count()
FROM test1
WHERE toYear(toDate(p)) = 1999;

-- non-optimized (toDate(DateTime) is always monotonic, but we cannot relaxing the predicates to do trivial count())
SELECT count()
FROM test1
WHERE p > toDateTime('2020-09-01 10:00:00'); -- { serverError TOO_MANY_ROWS }

-- optimized (partition expr wrapped with non-monotonic functions)
SELECT count()
FROM test1
WHERE toDate(p) = '2020-09-01'
    AND sipHash64(toString(toDate(p))) % 2 = 1;

SELECT count()
FROM test1
WHERE toDate(p) = '2020-09-01'
    AND sipHash64(toString(toDate(p))) % 2 = 0;

-- non-optimized (some predicate depends on non-partition_expr columns)
SELECT count()
FROM test1
WHERE toDate(p) = '2020-09-01'
    AND k = 2; -- { serverError TOO_MANY_ROWS }

-- optimized
SELECT count()
FROM test1
WHERE toDate(p) > '2020-09-01';

-- non-optimized
SELECT count()
FROM test1
WHERE toDate(p) >= '2020-09-01'
    AND p <= '2020-09-01 00:00:00';

CREATE TABLE test_tuple
(
    p DateTime,
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY (toDate(p), i)
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

INSERT INTO test_tuple;

-- optimized
SELECT count()
FROM test_tuple
WHERE toDate(p) > '2020-09-01';

-- optimized
SELECT count()
FROM test_tuple
WHERE toDate(p) > '2020-09-01'
    AND i = 1;

-- optimized
SELECT count()
FROM test_tuple
WHERE i > 2;

-- optimized
SELECT count()
FROM test_tuple
WHERE i < 1;

-- non-optimized
SELECT count()
FROM
    test_tuple
ARRAY JOIN [p, p] AS c
WHERE toDate(p) = '2020-09-01'; -- { serverError TOO_MANY_ROWS }

SELECT count()
FROM
    test_tuple
ARRAY JOIN [1, 2] AS c
WHERE toDate(p) = '2020-09-01'
SETTINGS max_rows_to_read = '4';

-- non-optimized
SELECT count()
FROM
    test_tuple
ARRAY JOIN [1, 2, 3] AS c
WHERE toDate(p) = '2020-09-01'; -- { serverError TOO_MANY_ROWS }

SELECT count()
FROM
    test_tuple
ARRAY JOIN [1, 2, 3] AS c
WHERE toDate(p) = '2020-09-01'
SETTINGS max_rows_to_read = '6';

CREATE TABLE test_two_args
(
    i int,
    j int,
    k int
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY i + j
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0';

INSERT INTO test_two_args;

-- optimized
SELECT count()
FROM test_two_args
WHERE i + j = 3;

-- non-optimized
SELECT count()
FROM test_two_args
WHERE i = 1; -- { serverError TOO_MANY_ROWS }

DROP TABLE test1;

DROP TABLE test_tuple;

DROP TABLE test_two_args;