-- { echo }
SELECT 1 IN (
        SELECT number
        FROM numbers(10)
    );

SELECT 1 IN (
        SELECT number
        FROM numbers(2, 10)
    );

SELECT 1 NOT IN (
        SELECT 1
        FROM numbers(10)
    );

SELECT 1 NOT IN (
        SELECT number
        FROM numbers(10)
    );

SELECT 1 IN (
        SELECT singleValueOrNull(*)
        FROM (
                SELECT 1
                FROM numbers(10)
            )
    );

SELECT 1 IN (
        SELECT singleValueOrNull(*)
        FROM (
                SELECT number
                FROM numbers(10)
            )
    );

SELECT 1 NOT IN (
        SELECT singleValueOrNull(*)
        FROM (
                SELECT 1
                FROM numbers(10)
            )
    );

SELECT 1 NOT IN (
        SELECT singleValueOrNull(*)
        FROM (
                SELECT number
                FROM numbers(10)
            )
    );

SELECT number AS a
FROM numbers(10)
WHERE a IN (
        SELECT number
        FROM numbers(3, 3)
    );

SELECT number AS a
FROM numbers(10)
WHERE a NOT IN (
        SELECT singleValueOrNull(*)
        FROM (
                SELECT 5
                FROM numbers(3, 3)
            )
    );

SELECT 1 < (
        SELECT max(*)
        FROM (
                SELECT 1
                FROM numbers(10)
            )
    );

SELECT 1 <= (
        SELECT max(*)
        FROM (
                SELECT 1
                FROM numbers(10)
            )
    );

SELECT 1 < (
        SELECT max(*)
        FROM (
                SELECT number
                FROM numbers(10)
            )
    );

SELECT 1 > (
        SELECT min(*)
        FROM (
                SELECT number
                FROM numbers(10)
            )
    );

SELECT 1 >= (
        SELECT min(*)
        FROM (
                SELECT number
                FROM numbers(10)
            )
    );

SELECT 11 > (
        SELECT max(*)
        FROM (
                SELECT number
                FROM numbers(10)
            )
    );

SELECT 11 <= (
        SELECT min(*)
        FROM (
                SELECT number
                FROM numbers(11)
            )
    );

SELECT 11 < (
        SELECT min(*)
        FROM (
                SELECT 11
                FROM numbers(10)
            )
    );

SELECT 11 > (
        SELECT max(*)
        FROM (
                SELECT 11
                FROM numbers(10)
            )
    );

SELECT 11 >= (
        SELECT max(*)
        FROM (
                SELECT 11
                FROM numbers(10)
            )
    );

SELECT sum(number) = any(number)
FROM numbers(1)
GROUP BY number;

SELECT 1 = any(1);