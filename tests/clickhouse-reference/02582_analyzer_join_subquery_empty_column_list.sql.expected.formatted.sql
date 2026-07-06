SET enable_analyzer = '1';

-- { echoOn }
SELECT a
FROM
    (
        SELECT 1 AS a
    ) AS t1,
    (
        SELECT
            2 AS b,
            3 AS c
    ) AS t2;

SELECT a
FROM
    (
        SELECT 1 AS a
        UNION ALL
        SELECT 1 AS a
    ) AS t1,
    (
        SELECT
            2 AS b,
            3 AS c
    ) AS t2;

SELECT a
FROM
    (
        SELECT 1 AS a
    ) AS t1,
    (
        SELECT
            2 AS b,
            3 AS c
        UNION ALL
        SELECT
            2 AS b,
            3 AS c
    ) AS t2;

SELECT a
FROM
    (
        SELECT 1 AS a
        UNION ALL
        SELECT 1 AS a
    ) AS t1,
    (
        SELECT
            2 AS b,
            3 AS c
        UNION ALL
        SELECT
            2 AS b,
            3 AS c
    ) AS t2;

SELECT a
FROM
    (
        SELECT *
        FROM (
                SELECT 1 AS a
                UNION ALL
                SELECT 1 AS a
            )
    ) AS t1,
    (
        SELECT *
        FROM (
                SELECT
                    2 AS b,
                    3 AS c
                UNION ALL
                SELECT
                    2 AS b,
                    3 AS c
            )
    ) AS t2;

SELECT b
FROM
    (
        SELECT 1 AS a
        UNION ALL
        SELECT 1 AS a
    ) AS t1,
    (
        SELECT
            2 AS b,
            3 AS c
        UNION ALL
        SELECT
            2 AS b,
            3 AS c
    ) AS t2;

SELECT c
FROM
    (
        SELECT 1 AS a
        UNION ALL
        SELECT 1 AS a
    ) AS t1,
    (
        SELECT
            2 AS b,
            3 AS c
        UNION ALL
        SELECT
            2 AS b,
            3 AS c
    ) AS t2;

SELECT 42
FROM
    (
        SELECT 1 AS a
        UNION ALL
        SELECT 1 AS a
    ) AS t1,
    (
        SELECT
            2 AS b,
            3 AS c
        UNION ALL
        SELECT
            2 AS b,
            3 AS c
    ) AS t2;

SELECT count()
FROM
    (
        SELECT 1 AS a
        UNION ALL
        SELECT 1 AS a
    ) AS t1,
    (
        SELECT
            2 AS b,
            3 AS c
        UNION ALL
        SELECT
            2 AS b,
            3 AS c
    ) AS t2;