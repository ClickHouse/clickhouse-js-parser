SET optimize_min_equality_disjunction_chain_length = '3';

EXPLAIN SYNTAX
SELECT *
FROM
    `system`.numbers AS a,
    `system`.numbers AS b,
    `system`.numbers AS c
WHERE a.number = 1
    OR a.number = 2
    OR a.number = 3
    OR a.number = 4
    OR a.number = 5;

EXPLAIN SYNTAX oneline = '1'
SELECT *
FROM
    `system`.numbers AS a,
    `system`.numbers AS b,
    `system`.numbers AS c
WHERE a.number = 1
    OR a.number = 2
    OR a.number = 3
    OR a.number = 4
    OR a.number = 5;

EXPLAIN SYNTAX run_query_tree_passes = '0'
SELECT *
FROM
    `system`.numbers AS a,
    `system`.numbers AS b,
    `system`.numbers AS c
WHERE a.number = 1
    OR a.number = 2
    OR a.number = 3
    OR a.number = 4
    OR a.number = 5;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT *
FROM
    `system`.numbers AS a,
    `system`.numbers AS b,
    `system`.numbers AS c
WHERE a.number = 1
    OR a.number = 2
    OR a.number = 3
    OR a.number = 4
    OR a.number = 5;

EXPLAIN SYNTAX run_query_tree_passes = '1', query_tree_passes = '1'
SELECT *
FROM
    `system`.numbers AS a,
    `system`.numbers AS b,
    `system`.numbers AS c
WHERE a.number = 1
    OR a.number = 2
    OR a.number = 3
    OR a.number = 4
    OR a.number = 5;

EXPLAIN SYNTAX run_query_tree_passes = '1', query_tree_passes = '0'
SELECT *
FROM
    `system`.numbers AS a,
    `system`.numbers AS b,
    `system`.numbers AS c
WHERE a.number = 1
    OR a.number = 2
    OR a.number = 3
    OR a.number = 4
    OR a.number = 5;

-- { echoOn }
EXPLAIN SYNTAX run_query_tree_passes = '1', oneline = '1'
SELECT *
FROM
    `system`.numbers AS a,
    `system`.numbers AS b,
    `system`.numbers AS c
WHERE a.number = 1
    OR a.number = 2
    OR a.number = 3
    OR a.number = 4
    OR a.number = 5;