SELECT
    Y,
    uniqHLL12(X)
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
    uniqHLL12(X)
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
    uniqHLL12(X)
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
    uniqHLL12(X)
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
    uniqHLL12(X)
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
    uniqHLL12(X)
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
    uniqHLL12(X)
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
    uniqHLL12(X)
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
    uniqHLL12(X)
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
    uniqHLL12(Z)
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
    uniqHLL12(Z)
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
    uniqHLL12(Z)
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

SELECT uniqHLL12(dummy)
FROM remote('127.0.0.{2,3}', `system`.one);

SELECT
    Y,
    uniqCombined(X)
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
    uniqCombined(X)
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
    uniqCombined(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(X)
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
    uniqCombined(X)
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
    uniqCombined(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(X)
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
    uniqCombined(X)
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
    uniqCombined(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(12)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(17)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(20)(X)
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
    uniqCombined(Z)
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
    uniqCombined(Z)
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
    uniqCombined(Z)
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

SELECT
    Y,
    uniqCombined(12)(Z)
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
    uniqCombined(12)(Z)
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
    uniqCombined(12)(Z)
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

SELECT
    Y,
    uniqCombined(17)(Z)
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
    uniqCombined(17)(Z)
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
    uniqCombined(17)(Z)
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

SELECT
    Y,
    uniqCombined(20)(Z)
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
    uniqCombined(20)(Z)
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
    uniqCombined(20)(Z)
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

SELECT uniqCombined(dummy)
FROM remote('127.0.0.{2,3}', `system`.one);

SELECT uniqCombined(12)(dummy)
FROM remote('127.0.0.{2,3}', `system`.one);

SELECT uniqCombined(17)(dummy)
FROM remote('127.0.0.{2,3}', `system`.one);

SELECT uniqCombined(20)(dummy)
FROM remote('127.0.0.{2,3}', `system`.one);