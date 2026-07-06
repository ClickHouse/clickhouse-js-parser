SET enable_analyzer = '1';

SET joined_subquery_requires_alias = '1';

SELECT *
FROM
    (
        SELECT
            1 AS A,
            2 AS B
    ) AS X
ALL LEFT JOIN (
        SELECT
            3 AS A,
            2 AS B
    ) AS Y
    USING (B);

SELECT *
FROM
    (
        SELECT
            1 AS A,
            2 AS B
    ) AS X
ALL LEFT JOIN (
        SELECT
            3 AS A,
            2 AS B
    )
    USING (B); -- { serverError ALIAS_REQUIRED }

SELECT *
FROM
    (
        SELECT
            1 AS A,
            2 AS B
    )
ALL LEFT JOIN (
        SELECT
            3 AS A,
            2 AS B
    ) AS Y
    USING (B); -- { serverError ALIAS_REQUIRED }

SET joined_subquery_requires_alias = '0';