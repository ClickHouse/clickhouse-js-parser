SET optimize_rewrite_sum_if_to_count_if = '0';

SELECT sumIf(1, number % 2 > 2)
FROM numbers(100);

SELECT
    sumIf(1 AS one_expr, number % 2 > 2 AS cond_expr),
    sum(cond_expr),
    one_expr
FROM numbers(100);

SELECT countIf(number % 2 > 2)
FROM numbers(100);

SELECT sumIf(1, number % 2 = 0)
FROM numbers(100);

SELECT
    sumIf(1 AS one_expr, number % 2 = 0 AS cond_expr),
    sum(cond_expr),
    one_expr
FROM numbers(100);

SELECT countIf(number % 2 = 0)
FROM numbers(100);

SELECT sum(if(number % 2 = 0, 1, 0))
FROM numbers(100);

SELECT
    sum(if(number % 2 = 0 AS cond_expr, 1 AS one_expr, 0 AS zero_expr) AS if_expr),
    sum(cond_expr),
    sum(if_expr),
    one_expr,
    zero_expr
FROM numbers(100);

SELECT sum(if(number % 2 = 0, 0, 1))
FROM numbers(100);

SELECT
    sum(if(number % 2 = 0 AS cond_expr, 0 AS zero_expr, 1 AS one_expr) AS if_expr),
    sum(cond_expr),
    sum(if_expr),
    one_expr,
    zero_expr
FROM numbers(100);

SELECT countIf(number % 2 != 0)
FROM numbers(100);

SET optimize_rewrite_sum_if_to_count_if = '1';

SET enable_analyzer = true;

EXPLAIN QUERY TREE run_passes = '1'
SELECT sumIf(123, number % 2 = 0)
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT sum(if(number % 2 = 0, 123, 0))
FROM numbers(100);

EXPLAIN QUERY TREE run_passes = '1'
SELECT sum(if(number % 2 = 0, 0, 123))
FROM numbers(100);