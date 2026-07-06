SELECT 1
FROM (
        SELECT 1 AS c0
        WHERE exists((
                SELECT 1
            ))
        LIMIT 1
    ) AS v0
GROUP BY v0.c0
HAVING v0.c0 = 1
SETTINGS exact_rows_before_limit = '1';

SELECT '---------';

SELECT 1
FROM (
        SELECT 1 AS c0
        WHERE exists((
                SELECT 1
            ))
        LIMIT 1
    ) AS v0
GROUP BY v0.c0
HAVING v0.c0 = 2
SETTINGS exact_rows_before_limit = '1';

SELECT 1
FROM (
        SELECT 1 AS c0
        WHERE exists((
                SELECT 1
            ))
        LIMIT 1
    ) AS v0
GROUP BY v0.c0
HAVING v0.c0 = 1
    AND v0.c0 = 1
SETTINGS exact_rows_before_limit = '1';

SELECT 1
FROM (
        SELECT 1 AS c0
        WHERE exists((
                SELECT 1
            ))
        LIMIT 1
    ) AS v0
GROUP BY v0.c0
HAVING v0.c0 = 1
    AND v0.c0 = 2
SETTINGS exact_rows_before_limit = '1';

SELECT 1
FROM (
        SELECT 1 AS c0
        WHERE exists((
                SELECT 1
            ))
        LIMIT 1
    ) AS v0
GROUP BY v0.c0
HAVING v0.c0 = 1
    OR v0.c0 = 1
SETTINGS exact_rows_before_limit = '1';

SELECT 1
FROM (
        SELECT 1 AS c0
        WHERE exists((
                SELECT 1
            ))
        LIMIT 1
    ) AS v0
GROUP BY v0.c0
HAVING v0.c0 = 1
    OR v0.c0 = 2
SETTINGS exact_rows_before_limit = '1';