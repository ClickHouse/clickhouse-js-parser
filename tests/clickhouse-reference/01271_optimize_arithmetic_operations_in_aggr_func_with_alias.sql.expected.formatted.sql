SET optimize_arithmetic_operations_in_aggregate_functions = '1';

SET convert_query_to_cnf = '0';

EXPLAIN SYNTAX
SELECT min((n AS a) + (1 AS b)) AS c
FROM (
        SELECT number AS n
        FROM numbers(10)
    )
WHERE a > 0
    AND b > 0
HAVING c > 0;

SELECT min((n AS a) + (1 AS b)) AS c
FROM (
        SELECT number AS n
        FROM numbers(10)
    )
WHERE a > 0
    AND b > 0
HAVING c > 0;

EXPLAIN SYNTAX
SELECT min(n + 1 AS a) AS c
FROM (
        SELECT number AS n
        FROM numbers(10)
    )
WHERE a > 0
HAVING c > 0;

SELECT min(n + 1 AS a) AS c
FROM (
        SELECT number AS n
        FROM numbers(10)
    )
WHERE a > 0
HAVING c > 0;

EXPLAIN SYNTAX
SELECT min(n + 1) AS c
FROM (
        SELECT number AS n
        FROM numbers(10)
    )
HAVING c > 0;

SELECT min(n + 1) AS c
FROM (
        SELECT number AS n
        FROM numbers(10)
    )
HAVING c > 0;