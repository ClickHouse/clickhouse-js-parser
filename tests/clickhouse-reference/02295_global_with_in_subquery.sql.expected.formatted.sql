-- https://github.com/ClickHouse/ClickHouse/issues/37141
WITH (
        SELECT 1
    ) AS v0

SELECT
    v0,
    v > 0
FROM (
        WITH (
                SELECT 1
            ) AS v1,

        (
                SELECT 2
            ) AS v2

        SELECT v1 AS v
        UNION ALL
        WITH (
                SELECT 1
            ) AS v1,

        (
                SELECT 2
            ) AS v2

        SELECT v2 AS v
    ) AS a;

SELECT number
FROM numbers(10)
WHERE number IN (
        WITH (
                SELECT 1
            ) AS v1,

        (
                SELECT 2
            ) AS v2

        SELECT v1 AS v
        UNION ALL
        WITH (
                SELECT 1
            ) AS v1,

        (
                SELECT 2
            ) AS v2

        SELECT v2 AS v
    );