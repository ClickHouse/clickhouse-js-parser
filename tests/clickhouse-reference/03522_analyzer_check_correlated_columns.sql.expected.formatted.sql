SET enable_analyzer = '1';

SELECT min(*) AS y
FROM (
        SELECT 1 IN (
                SELECT y
            )
    );

WITH toDateTime(*) AS t

SELECT t IN (
        SELECT t
        WHERE t IN (
                SELECT t
            )
    );

SELECT
    (
        SELECT min(*)
        FROM (
                SELECT t0.c0
            )
    ) AS a0,
    (
        SELECT a0
    )
FROM (
        SELECT 1 AS c0
    ) AS t0
SETTINGS allow_experimental_correlated_subqueries = '1'; -- { serverError NOT_IMPLEMENTED }