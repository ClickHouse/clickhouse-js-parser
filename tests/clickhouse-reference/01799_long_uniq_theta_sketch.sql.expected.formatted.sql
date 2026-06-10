-- Tags: long, no-fasttest
-- The result slightly differs but it's ok since `uniqueTheta` is an approximate function.
SET max_bytes_before_external_group_by = '0', max_bytes_ratio_before_external_group_by = '0';

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            (3 * X * X - 7 * X + 11) % 37 AS Y
        FROM `system`.numbers
        LIMIT 15
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            (3 * X * X - 7 * X + 11) % 37 AS Y
        FROM `system`.numbers
        LIMIT 3000
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            (3 * X * X - 7 * X + 11) % 37 AS Y
        FROM `system`.numbers
        LIMIT 1000000
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            round(1 / (1 + (3 * X * X - 7 * X + 11) % 37), 3) AS Y
        FROM `system`.numbers
        LIMIT 15
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            round(1 / (1 + (3 * X * X - 7 * X + 11) % 37), 3) AS Y
        FROM `system`.numbers
        LIMIT 3000
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            round(1 / (1 + (3 * X * X - 7 * X + 11) % 37), 3) AS Y
        FROM `system`.numbers
        LIMIT 1000000
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            round(toFloat32(1 / (1 + (3 * X * X - 7 * X + 11) % 37)), 3) AS Y
        FROM `system`.numbers
        LIMIT 15
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            round(toFloat32(1 / (1 + (3 * X * X - 7 * X + 11) % 37)), 3) AS Y
        FROM `system`.numbers
        LIMIT 3000
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(X)
FROM (
        SELECT
            number AS X,
            round(toFloat32(1 / (1 + (3 * X * X - 7 * X + 11) % 37)), 3) AS Y
        FROM `system`.numbers
        LIMIT 1000000
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(Z)
FROM (
        SELECT
            number AS X,
            IPv4NumToString(toUInt32(X)) AS Z,
            (3 * X * X - 7 * X + 11) % 37 AS Y
        FROM `system`.numbers
        LIMIT 15
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(Z)
FROM (
        SELECT
            number AS X,
            IPv4NumToString(toUInt32(X)) AS Z,
            (3 * X * X - 7 * X + 11) % 37 AS Y
        FROM `system`.numbers
        LIMIT 3000
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT
    Y,
    uniqTheta(Z)
FROM (
        SELECT
            number AS X,
            IPv4NumToString(toUInt32(X)) AS Z,
            (3 * X * X - 7 * X + 11) % 37 AS Y
        FROM `system`.numbers
        LIMIT 1000000
    )
GROUP BY Y
ORDER BY Y ASC;

SELECT uniqTheta(dummy)
FROM remote('127.0.0.{2,3}', `system`.one);

SELECT uniqExact(number)
FROM numbers(10000000.);

SELECT uniqCombined(number)
FROM numbers(10000000.);

SELECT uniqCombined64(number)
FROM numbers(10000000.);

SELECT uniqTheta(number)
FROM numbers(10000000.);