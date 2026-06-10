-- Tags: no-parallel-replicas
WITH sub AS (
    SELECT number
    FROM numbers(1)
)

SELECT x
FROM (
        SELECT number AS x
        FROM remote('127.0.0.{1,2}', numbers(2))
    )
WHERE x IN (sub)
SETTINGS
    allow_push_predicate_ast_for_distributed_subqueries = '1',
    enable_analyzer = '1';

WITH sub AS (
    SELECT number
    FROM numbers(1)
)

SELECT x
FROM (
        SELECT number AS x
        FROM remote('127.0.0.{1,2}', numbers(2))
    )
WHERE x GLOBAL IN (sub)
SETTINGS
    allow_push_predicate_ast_for_distributed_subqueries = '1',
    enable_analyzer = '1';