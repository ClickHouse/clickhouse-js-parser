SET join_use_nulls = '1';

SELECT *
FROM
    (
        SELECT
            number,
            ['left'] AS ar,
            number AS left_number
        FROM `system`.numbers
        LIMIT 2
    ) AS js1
FULL JOIN (
        SELECT
            number,
            ['right'] AS ar,
            number AS right_number
        FROM `system`.numbers
        LIMIT 2
        OFFSET 1
    ) AS js2
    USING (number)
ORDER BY number ASC;

SELECT *
FROM
    (
        SELECT
            ['left'] AS ar,
            number AS left_number
        FROM `system`.numbers
        LIMIT 2
    ) AS js1
FULL JOIN (
        SELECT
            ['right'] AS ar,
            number AS right_number
        FROM `system`.numbers
        LIMIT 2
        OFFSET 1
    ) AS js2
    ON left_number = right_number
ORDER BY left_number ASC;

SELECT *
FROM
    (
        SELECT
            ['left'] AS ar,
            42 AS left_number
    ) AS js1
FULL JOIN (
        SELECT
            ['right'] AS ar,
            42 AS right_number
    ) AS js2
    USING (ar)
ORDER BY left_number ASC;