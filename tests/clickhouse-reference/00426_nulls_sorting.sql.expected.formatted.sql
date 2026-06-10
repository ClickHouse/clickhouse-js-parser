SELECT arrayJoin([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 3, 4, 12, NULL]) AS x
ORDER BY x ASC;

SELECT arrayJoin([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 3, 4, 12, NULL]) AS x
ORDER BY x DESC;

SET max_block_size = '1000';

SELECT nullIf(number, number % 3 = 0 ? number : 0) AS x
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 10
    )
ORDER BY x ASC;

SELECT nullIf(number, number % 3 = 0 ? number : 0) AS x
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 10
    )
ORDER BY x DESC;

SET max_block_size = '5';

SELECT
    nullIf(number, number % 3 = 0 ? number : 0) AS x,
    number AS y
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 10
    )
ORDER BY
    x ASC,
    y ASC;

SELECT
    nullIf(number, number % 3 = 0 ? number : 0) AS x,
    number AS y
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 10
    )
ORDER BY
    x DESC,
    y ASC;

SELECT x
FROM (
        SELECT toNullable(number) AS x
        FROM `system`.numbers
        LIMIT 3
    )
ORDER BY x DESC
LIMIT 10;