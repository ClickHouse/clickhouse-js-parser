SELECT
    x,
    y
FROM
    (
        SELECT number AS x
        FROM `system`.numbers
        LIMIT 3
    ) AS js1
CROSS JOIN (
        SELECT number AS y
        FROM `system`.numbers
        LIMIT 5
    ) AS js2
ORDER BY
    x ASC,
    y ASC;

SET join_algorithm = 'auto';

-- Just to test that we preserved old setting name this we use `enable_analyzer` instead of `enable_analyzer` here.
SET enable_analyzer = '1';