CREATE TABLE `left`
(
    g UInt32,
    i UInt32
)
ORDER BY (g, i);

INSERT INTO `left`;

CREATE TABLE `right`
(
    g UInt32,
    i UInt32
)
ORDER BY (g, i);

INSERT INTO `right`;

SET enable_analyzer = '1';

WITH differences AS (
(    SELECT
        g,
        i
    FROM `left`
    WHERE g >= 0
        AND g <= 10
EXCEPT
    SELECT
        g,
        i
    FROM `right`
    WHERE g >= 0
        AND g <= 10)
    UNION ALL
(    SELECT
        g,
        i
    FROM `right`
    WHERE g >= 0
        AND g <= 10
EXCEPT
    SELECT
        g,
        i
    FROM `left`
    WHERE g >= 0
        AND g <= 10)
),

diff_counts AS (
    SELECT
        g,
        count(*)
    FROM differences
    GROUP BY g
)

SELECT *
FROM diff_counts
ORDER BY g ASC;

WITH differences AS (
(    SELECT
        g,
        i
    FROM `left`
    WHERE g >= 0
        AND g <= 10
EXCEPT
    SELECT
        g,
        i
    FROM `right`
    WHERE g >= 0
        AND g <= 10)
    UNION ALL
(    SELECT
        g,
        i
    FROM `right`
    WHERE g >= 0
        AND g <= 10
EXCEPT
    SELECT
        g,
        i
    FROM `left`
    WHERE g >= 0
        AND g <= 10)
),

diff_counts AS (
    SELECT
        g,
        count(ignore(*))
    FROM differences
    GROUP BY g
)

SELECT *
FROM diff_counts
ORDER BY g ASC;