-- https://github.com/ClickHouse/ClickHouse/issues/11757
SET enable_analyzer = '1';

SELECT *
FROM
    (
        SELECT [1, 2] AS a
    ) AS aa
CROSS JOIN (
        SELECT [3, 4] AS b
    ) AS bb
ARRAY JOIN aa.a, bb.b;