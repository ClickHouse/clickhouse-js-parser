SELECT
    t1.k,
    t2.k
FROM
    (
        SELECT number AS k
        FROM numbers(10)
    ) AS t1
INNER JOIN (
        SELECT
            CAST(0 AS UInt64) AS k,
            k
        FROM numbers(3)
    ) AS t2
    ON t1.k = t2.k
ORDER BY
    t1.k ASC,
    t2.k ASC;