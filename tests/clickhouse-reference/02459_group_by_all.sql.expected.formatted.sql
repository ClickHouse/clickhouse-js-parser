DROP TABLE IF EXISTS group_by_all;

CREATE TABLE group_by_all
(
    a String,
    b int,
    c int
)
ENGINE = Memory();

INSERT INTO group_by_all;

SELECT
    a,
    count(b)
FROM group_by_all
GROUP BY ALL
ORDER BY a ASC;

SELECT
    substring(a, 1, 3),
    count(b)
FROM group_by_all
GROUP BY ALL;

SELECT
    substring(a, 1, 3),
    substring(substring(a, 1, 2), 1, count(b))
FROM group_by_all
GROUP BY ALL;

SELECT
    substring(a, 1, 3),
    substring(substring(a, 1, 2), c, count(b))
FROM group_by_all
GROUP BY ALL;

SELECT
    substring(a, 1, 3),
    substring(substring(a, c, 2), c, count(b))
FROM group_by_all
GROUP BY ALL;

SELECT
    substring(a, 1, 3),
    substring(substring(a, c + 1, 2), 1, count(b))
FROM group_by_all
GROUP BY ALL;

SELECT
    substring(a, 1, 3),
    substring(substring(a, c + 1, 2), c, count(b))
FROM group_by_all
GROUP BY ALL;

SELECT
    substring(a, 1, 3),
    substring(substring(substring(a, c, count(b)), 1, count(b)), 1, count(b))
FROM group_by_all
GROUP BY ALL;

SELECT
    substring(a, 1, 3),
    substring(a, 1, count(b))
FROM group_by_all
GROUP BY ALL;

SELECT
    count(b) AS len,
    substring(a, 1, 3),
    substring(a, 1, len)
FROM group_by_all
GROUP BY ALL;

SET enable_analyzer = '1';