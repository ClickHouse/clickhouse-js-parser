SET enable_analyzer = true;

-- { echoOn }
SET optimize_rewrite_aggregate_function_with_if = false;

EXPLAIN QUERY TREE run_passes = '1'
SELECT sum(if(number % 2, number, 0))
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT sum(if(number % 2, 0, number))
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT sum(if(number % 2, number, NULL))
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT sum(if(number % 2, NULL, number))
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT avg(if(number % 2, number, NULL))
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT avg(if(number % 2, NULL, number))
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT quantiles(0.5, 0.9, 0.99)(if(number % 2, number, NULL))
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT quantiles(0.5, 0.9, 0.99)(if(number % 2, NULL, number))
FROM numbers(100);

SET optimize_rewrite_aggregate_function_with_if = true;