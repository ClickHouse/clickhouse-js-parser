SELECT *
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 1
        UNION ALL
        SELECT *
        FROM `system`.numbers
        LIMIT 2
        UNION ALL
        SELECT *
        FROM `system`.numbers
        LIMIT 3
    )
ORDER BY number ASC;

SELECT *
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 1
        UNION ALL
        SELECT *
        FROM `system`.numbers
        LIMIT 2
        UNION ALL
        SELECT *
        FROM `system`.numbers
        LIMIT 3
    )
ORDER BY number ASC;

SELECT count()
FROM view(    SELECT 1
    UNION ALL
    SELECT 2
    UNION ALL
    SELECT 3);