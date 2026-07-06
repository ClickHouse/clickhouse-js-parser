-- https://github.com/ClickHouse/ClickHouse/issues/25655
SET enable_analyzer = '1';

SELECT
    sum(t.b) / 1 AS a,
    sum(t.a)
FROM (
        SELECT
            1 AS a,
            2 AS b
    ) AS t;