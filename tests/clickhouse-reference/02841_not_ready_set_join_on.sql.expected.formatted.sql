WITH l_t AS (
    SELECT 42 AS key
)

SELECT *
FROM
    l_t
INNER JOIN numbers(50) AS r_t
    ON l_t.key = r_t.number
    AND r_t.number IN (
        SELECT number * 2
        FROM numbers(1000.)
    )
SETTINGS enable_analyzer = '0';

WITH l_t AS (
    SELECT 42 AS key
)

SELECT *
FROM
    l_t
INNER JOIN numbers(50) AS r_t
    ON l_t.key = r_t.number
    AND r_t.number IN (
        SELECT number * 2
        FROM numbers(1000.)
    )
SETTINGS enable_analyzer = '1';

WITH l_t AS (
    SELECT 42 AS key
)

SELECT *
FROM
    l_t
INNER JOIN numbers(50) AS r_t
    ON l_t.key = r_t.number
    AND r_t.number GLOBAL IN (
        SELECT number * 2
        FROM numbers(1000.)
    )
SETTINGS enable_analyzer = '1';

WITH l_t AS (
    SELECT 42 AS key
)

SELECT *
FROM
    l_t
INNER JOIN numbers(50) AS r_t
    ON l_t.key = r_t.number
    AND r_t.number GLOBAL IN (
        SELECT number * 2
        FROM numbers(1000.)
    )
SETTINGS enable_analyzer = '0';