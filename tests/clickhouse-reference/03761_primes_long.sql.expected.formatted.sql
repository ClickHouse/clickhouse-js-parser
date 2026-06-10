-- Tags: long
SET max_rows_to_read = '150000000';

WITH toUInt64(1000000000000000.) AS lo,

lo + 2000000 AS hi

SELECT
    p.prime,
    q.prime
FROM
    (
        SELECT prime
        FROM `system`.primes
        WHERE prime >= lo
            AND prime <= hi
    ) AS p
INNER JOIN (
        SELECT prime
        FROM `system`.primes
        WHERE prime >= lo
            AND prime <= hi + 2
    ) AS q
    ON q.prime = p.prime + 2
ORDER BY p.prime ASC
LIMIT 100;

WITH toUInt64(1000000000000000.) AS lo,

lo + 2000000 AS hi

SELECT
    p.prime,
    q.prime
FROM
    (
        SELECT prime
        FROM `system`.primes
        WHERE prime >= lo
            AND prime <= hi
    ) AS p
INNER JOIN (
        SELECT prime
        FROM `system`.primes
        WHERE prime >= 2 * lo + 1
            AND prime <= 2 * hi + 1
    ) AS q
    ON q.prime = 2 * p.prime + 1
ORDER BY p.prime ASC
LIMIT 100;

SELECT prime
FROM `system`.primes
WHERE bitAnd(prime, prime + 1) = 0
LIMIT 7;

SELECT prime
FROM `system`.primes
WHERE bitAnd(prime, prime + 1) = 0
LIMIT 4
OFFSET 3;

SELECT count()
FROM `system`.primes
WHERE prime < 1000000000;