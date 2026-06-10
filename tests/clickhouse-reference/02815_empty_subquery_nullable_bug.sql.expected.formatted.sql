SELECT *
FROM (
        SELECT (
                SELECT 0 AS x
                FROM
                    (
                        SELECT 1 AS x
                    ) AS t1
                INNER JOIN (
                        SELECT 1 AS x
                    ) AS t2
                    USING (x)
            ) AS x
        FROM (
                SELECT 1 AS x
            )
    )
FORMAT Null;

SELECT x IN (111) = 1
FROM (
        SELECT (
                SELECT CAST('3' AS Nullable(UInt8))
                WHERE 0
            ) AS x
        FROM (
                SELECT 2 AS x
            )
    )
FORMAT Null;

SELECT x IN (111) = 1
FROM (
        SELECT (
                SELECT CAST('3' AS Nullable(UInt8))
                WHERE 1
            ) AS x
        FROM (
                SELECT 2 AS x
            )
    )
FORMAT Null;

SELECT x IN (111) = 1
FROM (
        SELECT (
                SELECT 3
                WHERE 0
            ) AS x
        FROM (
                SELECT 2 AS x
            )
    )
FORMAT Null;

SELECT
    x,
    (
        SELECT 1
        WHERE NULL
    ) AS x
FORMAT Null;