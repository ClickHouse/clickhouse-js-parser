SELECT count() AS cnt
WHERE 0
HAVING cnt = 0;

SELECT cnt
FROM (
        SELECT count() AS cnt
        WHERE 0
    )
WHERE cnt = 0;

SELECT cnt
FROM (
        SELECT count() AS cnt
        FROM `system`.one
        WHERE 0
    )
WHERE cnt = 0;

SELECT sum
FROM (
        SELECT sum(dummy) AS sum
        FROM `system`.one
        WHERE 0
    )
WHERE sum = 0;

SET aggregate_functions_null_for_empty = '1';

SELECT sum
FROM (
        SELECT sum(dummy) AS sum
        FROM `system`.one
        WHERE 0
    )
WHERE sum IS NULL;