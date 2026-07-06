SET enable_analyzer = '1';

SELECT *
FROM
    (
        SELECT 1 AS a
    ) AS t
LEFT JOIN (
        SELECT 1 AS b
        WHERE false
    ) AS u
    ON true;