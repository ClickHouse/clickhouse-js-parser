-- https://github.com/ClickHouse/ClickHouse/issues/11813
SET enable_analyzer = '1';

SELECT 1
FROM
    (
        SELECT 1 AS x
    ) AS l
INNER JOIN (
        SELECT
            1 AS y,
            [1] AS a
    ) AS r
    ON l.x = r.y
ARRAY JOIN r.a;