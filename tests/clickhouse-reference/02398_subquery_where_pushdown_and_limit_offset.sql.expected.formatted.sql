DROP TABLE IF EXISTS t;

CREATE TABLE t
ENGINE = Log() AS
SELECT *
FROM `system`.numbers
LIMIT 20;

SET enable_optimize_predicate_expression = '1';

SELECT number
FROM (
        SELECT number
        FROM t
        ORDER BY number DESC
        OFFSET 3
    )
WHERE number < 18;

EXPLAIN SYNTAX
SELECT number
FROM (
        SELECT number
        FROM t
        ORDER BY number DESC
        OFFSET 3
    )
WHERE number < 18;

SELECT number
FROM (
        SELECT number
        FROM t
        ORDER BY number ASC
        LIMIT 5
    )
WHERE number % 2;

EXPLAIN SYNTAX
SELECT number
FROM (
        SELECT number
        FROM t
        ORDER BY number ASC
        LIMIT 5
    )
WHERE number % 2;

DROP TABLE t;