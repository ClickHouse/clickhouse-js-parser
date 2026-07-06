-- https://github.com/ClickHouse/ClickHouse/issues/10276
SET enable_analyzer = '1';

SELECT
    sum(x.n) AS n,
    sum(z.n) AS n2
FROM
    (
        SELECT
            1000 AS n,
            1 AS id
    ) AS x
INNER JOIN (
        SELECT
            10000 AS n,
            1 AS id
    ) AS y
    ON x.id = y.id
LEFT JOIN (
        SELECT
            100000 AS n,
            1 AS id
    ) AS z
    ON x.id = z.id;