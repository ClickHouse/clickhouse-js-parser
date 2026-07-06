SET join_algorithm = 'partial_merge';

SELECT NULL
FROM
    (
        SELECT
            NULL,
            1 AS a,
            CAST('0' AS Nullable(UInt8)) AS c
        UNION ALL
        SELECT
            NULL,
            65536,
            NULL
    ) AS js1
ALL LEFT JOIN (
        SELECT CAST('2' AS Nullable(UInt8)) AS a
    ) AS js2
    USING (a)
ORDER BY c ASC;