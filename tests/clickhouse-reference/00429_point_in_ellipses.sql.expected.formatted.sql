SELECT pointInEllipses(33.3, 55.3, 33.4, 55.1, 1., 1.) AS distance;

SELECT pointInEllipses(33.3 + v, 55.3 + v, 33.4, 55.1, 1., 1.) AS distance
FROM (
        SELECT number + 0.1 AS v
        FROM `system`.numbers
        LIMIT 1
    );

SELECT pointInEllipses(33.3, 55.3, 33.4, 55.1, 0.1, 0.2) AS distance;