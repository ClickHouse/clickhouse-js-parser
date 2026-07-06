SET enable_analyzer = '1';

WITH 1 AS x

SELECT x;

WITH 1 AS x

SELECT *
FROM (
        SELECT x
    );

WITH 1 AS x

SELECT
    *,
    x
FROM (
        WITH 2 AS x

        SELECT x AS y
    );

WITH 1 AS x

SELECT x
UNION ALL
WITH 1 AS x

SELECT x;

SELECT x
FROM (
        WITH 1 AS x

        SELECT x
        UNION ALL
        WITH 2 AS x

        SELECT x
    )
ORDER BY x ASC;

WITH 5 AS q1,

x AS (
    SELECT
        number + 100 AS b,
        number AS a
    FROM numbers(10)
    WHERE number > q1
)

SELECT *
FROM x;

EXPLAIN SYNTAX
WITH 1 AS x

SELECT x;

EXPLAIN SYNTAX
WITH 1 AS x

SELECT *
FROM (
        SELECT x
    );

EXPLAIN SYNTAX
WITH 1 AS x

SELECT
    *,
    x
FROM (
        WITH 2 AS x

        SELECT x AS y
    );

EXPLAIN SYNTAX
WITH 1 AS x

SELECT x
UNION ALL
WITH 1 AS x

SELECT x;

EXPLAIN SYNTAX
WITH 1 AS x

SELECT x
UNION ALL
WITH 2 AS x

SELECT x;

EXPLAIN SYNTAX
WITH 5 AS q1,

x AS (
    SELECT
        number + 100 AS b,
        number AS a
    FROM numbers(10)
    WHERE number > q1
)

SELECT *
FROM x;