SET max_memory_usage = '50000000';

SET join_algorithm = 'partial_merge';

SELECT count(1)
FROM (
        SELECT t2.n
        FROM
            numbers(10) AS t1
        INNER JOIN (
                SELECT
                    toUInt32(1) AS k,
                    number AS n
                FROM numbers(100)
            ) AS t2
            ON toUInt32(t1.number) = t2.k
        INNER JOIN (
                SELECT
                    toUInt32(1) AS k,
                    number AS n
                FROM numbers(100)
            ) AS t3
            ON t2.k = t3.k
        INNER JOIN (
                SELECT
                    toUInt32(1) AS k,
                    number AS n
                FROM numbers(100)
            ) AS t4
            ON t2.k = t4.k
    );