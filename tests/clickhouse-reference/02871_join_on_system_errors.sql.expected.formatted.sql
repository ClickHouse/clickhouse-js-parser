-- Unique table alias to distinguish between errors from different queries
SELECT *
FROM
    (
        SELECT 1 AS a
    ) AS t
INNER JOIN (
        SELECT 2 AS a
    ) AS `89467d35-77c2-4f82-ae7a-f093ff40f4cd`
    ON t.a = `89467d35-77c2-4f82-ae7a-f093ff40f4cd`.a;

SELECT *
FROM `system`.errors
WHERE name = 'UNKNOWN_IDENTIFIER'
    AND last_error_time > now() - 1
    AND last_error_message LIKE '%Missing columns%89467d35-77c2-4f82-ae7a-f093ff40f4cd%';