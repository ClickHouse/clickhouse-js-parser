SELECT (
        SELECT 1
        WHERE 0
    );

SELECT (
        SELECT *
        FROM (
                SELECT *
                FROM `system`.numbers
                LIMIT 2
            )
        WHERE number = number + 1
    );

SELECT (
        SELECT NULL
        WHERE 0
    );

SELECT (
        SELECT NULL
        WHERE NULL IS NOT NULL
    );

SELECT (
        SELECT NULL
        WHERE 1
    );

SELECT CAST(NULL AS Nullable(Nothing));

SELECT (
        SELECT CAST(NULL AS Nullable(Nothing))
        WHERE 0
    );

SELECT
    (
        SELECT 1
        WHERE 0
    ) AS a,
    (
        SELECT 1
        WHERE 1
    ) AS b
FORMAT TSVWithNames;