SET enable_analyzer = true;

SET optimize_rewrite_array_exists_to_has = false;

EXPLAIN QUERY TREE run_passes = '1'
SELECT arrayExists((x -> x = 5), materialize(range(10)))
FROM numbers(10);

EXPLAIN QUERY TREE run_passes = '1'
SELECT arrayExists((x -> 5 = x), materialize(range(10)))
FROM numbers(10);

SET optimize_rewrite_array_exists_to_has = true;

SET enable_analyzer = false;

EXPLAIN SYNTAX
SELECT arrayExists((x -> x = 5), materialize(range(10)))
FROM numbers(10);

EXPLAIN SYNTAX
SELECT arrayExists((x -> 5 = x), materialize(range(10)))
FROM numbers(10);