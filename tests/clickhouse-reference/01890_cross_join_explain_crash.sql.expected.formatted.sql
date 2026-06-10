SET enable_analyzer = '1';

SET joined_subquery_requires_alias = '0';

SELECT *
FROM
    (
        SELECT 1
    ),
    (
        SELECT 1
    ),
    (
        SELECT 1
    );

SELECT *
FROM
    (
        SELECT 2
    ),
    (
        SELECT 1
    ) AS a,
    (
        SELECT 1
    ) AS b;

SELECT *
FROM
    (
        SELECT 1
    ) AS a,
    (
        SELECT 2
    ),
    (
        SELECT 1
    ) AS b;

SELECT *
FROM
    (
        SELECT 1
    ) AS a,
    (
        SELECT 1
    ) AS b,
    (
        SELECT 2
    );