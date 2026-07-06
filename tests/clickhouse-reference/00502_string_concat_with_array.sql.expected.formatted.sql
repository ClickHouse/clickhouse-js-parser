SELECT
    a,
    b || b
FROM (
        SELECT
            [number] AS a,
            toString(number) AS b
        FROM `system`.numbers
        LIMIT 2
    );