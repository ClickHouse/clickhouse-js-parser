-- https://github.com/ClickHouse/ClickHouse/issues/61238
SET enable_analyzer = '1';

WITH (
        SELECT number
        FROM `system`.numbers
        LIMIT 1
    ) AS w1,

(
        SELECT number
        FROM `system`.numbers
        LIMIT 1
    ) AS w2,

(
        SELECT number
        FROM `system`.numbers
        LIMIT 1
    ) AS w3,

(
        SELECT number
        FROM `system`.numbers
        LIMIT 1
    ) AS w4,

(
        SELECT number
        FROM `system`.numbers
        LIMIT 1
    ) AS w5,

(
        SELECT number
        FROM `system`.numbers
        LIMIT 1
    ) AS w6

SELECT number
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 10
        UNION ALL
        SELECT number
        FROM `system`.numbers
        LIMIT 10
    )
WHERE number < 5;