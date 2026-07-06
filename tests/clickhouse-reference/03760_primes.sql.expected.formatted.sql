-- { echoOn }
SET max_block_size = '16';

SELECT
    database,
    name
FROM `system`.tables
WHERE database = 'system'
    AND name = 'primes';

SELECT prime
FROM `system`.primes
LIMIT 10;

SELECT prime
FROM `system`.primes
LIMIT 20;

SELECT
    count(),
    min(prime),
    max(prime)
FROM `system`.primes
WHERE prime < 20;

SELECT prime
FROM `system`.primes
WHERE prime < 20;

SELECT prime
FROM `system`.primes
WHERE prime < 20
LIMIT 3;

SELECT prime
FROM `system`.primes
WHERE prime < 20
LIMIT -3;

SELECT count()
FROM `system`.primes
WHERE prime < 2;

SELECT count()
FROM `system`.primes
WHERE prime = 1;

SELECT prime
FROM `system`.primes
WHERE prime <= 2;

SELECT prime
FROM `system`.primes
WHERE prime = 17;

SELECT
    count(),
    min(prime),
    max(prime)
FROM `system`.primes
WHERE prime >= 100
    AND prime <= 200;

SELECT prime
FROM `system`.primes
WHERE prime >= 100
    AND prime <= 110;

SELECT prime
FROM `system`.primes
WHERE prime > 50
    AND prime < 30;

SELECT prime
FROM `system`.primes
WHERE prime >= 200
    AND prime <= 220
    OR prime >= 100
    AND prime <= 120
    OR prime >= 110
    AND prime <= 130
    OR prime IN (97, 101, 109);

SELECT prime
FROM `system`.primes
WHERE prime > 10
    AND prime < 20
    OR prime >= 17
    AND prime <= 23
    OR prime IN (19, 23, 29)
    OR prime >= 30
    AND prime <= 40;

SELECT prime
FROM `system`.primes
WHERE prime IN (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);

SELECT prime
FROM `system`.primes
WHERE prime IN (17, 19, 21);

SELECT prime
FROM `system`.primes
WHERE prime < 10
    OR prime >= 100
    AND prime <= 110;

SELECT prime
FROM `system`.primes
LIMIT 10
OFFSET 5;

SELECT prime
FROM `system`.primes
LIMIT 100;

SELECT prime
FROM `system`.primes
WHERE prime > 1000
LIMIT 10;

SELECT count()
FROM `system`.primes
WHERE prime >= 14
    AND prime <= 16;

SELECT prime
FROM `system`.primes
WHERE prime < 20
ORDER BY prime DESC
LIMIT 3;

SELECT prime
FROM primes()
LIMIT 10;

SELECT count()
FROM primes(0);

SELECT prime
FROM primes(10);

SELECT prime
FROM primes(0, 5);

SELECT prime
FROM primes(3, 5);

SELECT prime
FROM primes(3, 5, 2);

SELECT prime
FROM primes(3, 5, 3);

SELECT prime
FROM primes(1, 1);

SELECT prime
FROM primes(2, 2);

SELECT prime
FROM primes(1, 10, 2);

SELECT prime
FROM primes(1, 100)
WHERE prime >= 50
    AND prime <= 70;

SELECT prime
FROM primes(1, 100, 2)
WHERE prime >= 50
    AND prime <= 70;

SELECT prime
FROM primes(1, 100, 2)
WHERE prime >= 50
    AND prime <= 90
LIMIT 2;

SELECT prime
FROM primes(1, 100, 2)
WHERE prime >= 50
    AND prime <= 90
LIMIT -2;

SELECT prime
FROM `system`.primes
WHERE prime > 100000
    AND prime < 100100;

SELECT prime
FROM `system`.primes
WHERE prime = 3000017;

SELECT prime
FROM `system`.primes
WHERE prime >= 3000000
    AND prime <= 3000100;

SELECT prime
FROM `system`.primes
LIMIT 10
OFFSET 100000;

SELECT *
FROM primes(0, 0);

SELECT *
FROM primes(1, 2, 3, 4); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT *
FROM primes(0, 10, 0); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM primes('10'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT *
FROM primes(NULL); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT *
FROM primes(*, 10); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM primes(-1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT *
FROM primes(18446744073709552000.); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT *
FROM primes(rand()); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM primes(10, -5); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT *
FROM `system`.primes
WHERE (prime + 10) % 5 = 1
LIMIT 10;

SELECT prime
FROM `system`.primes
WHERE prime >= toUInt64(100000000000000.)
    AND prime <= toUInt64(100000000000000.) + 100;

SELECT prime
FROM `system`.primes
WHERE prime > toUInt64(1000000000000000.)
LIMIT 1;

SELECT prime
FROM `system`.primes
WHERE prime >= toUInt64(100000.)
    AND prime <= toUInt64(100000.) + 100
    OR prime >= toUInt64(1000000.)
    AND prime <= toUInt64(1000000.) + 100
    OR prime >= toUInt64(10000000.)
    AND prime <= toUInt64(10000000.) + 100
    OR prime >= toUInt64(100000000.)
    AND prime <= toUInt64(100000000.) + 100
    OR prime >= toUInt64(1000000000.)
    AND prime <= toUInt64(1000000000.) + 100
    OR prime >= toUInt64(100000000000.)
    AND prime <= toUInt64(100000000000.) + 100
    OR prime >= toUInt64(1000000000000.)
    AND prime <= toUInt64(1000000000000.) + 100
    OR prime >= toUInt64(10000000000000.)
    AND prime <= toUInt64(10000000000000.) + 100
    OR prime >= toUInt64(100000000000000.)
    AND prime <= toUInt64(100000000000000.) + 100
    OR prime >= toUInt64(100000000000000.) + 1000
    AND prime <= toUInt64(100000000000000.) + 1100
    OR prime >= toUInt64(100000000000000.) + 100000
    AND prime <= toUInt64(100000000000000.) + 100100
    OR prime >= toUInt64(100000000000000.) + 100000000
    AND prime <= toUInt64(100000000000000.) + 100000100
    OR prime >= toUInt64(100000000000000.) + 10000000000
    AND prime <= toUInt64(100000000000000.) + 10000000100
    OR prime >= toUInt64(100000000000000.) + 1000000000000
    AND prime <= toUInt64(100000000000000.) + 1000000000100
    OR prime >= toUInt64(100000000000000.) + 100000000000000
    AND prime <= toUInt64(100000000000000.) + 100000000000100
    OR prime IN ([2])
    OR prime = 3;

SELECT prime
FROM `system`.primes
WHERE prime = 65537;