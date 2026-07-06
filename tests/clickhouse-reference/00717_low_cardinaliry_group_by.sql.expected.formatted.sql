DROP TABLE IF EXISTS tab_00717;

CREATE TABLE tab_00717
(
    a String,
    b LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO tab_00717;

SELECT count()
FROM tab_00717;

SELECT a
FROM tab_00717
GROUP BY a
ORDER BY a ASC;

SELECT b
FROM tab_00717
GROUP BY b
ORDER BY b ASC;

SELECT length(b) AS l
FROM tab_00717
GROUP BY l;

SELECT
    sum(length(a)),
    b
FROM tab_00717
GROUP BY b
ORDER BY b ASC;

SELECT
    sum(length(b)),
    a
FROM tab_00717
GROUP BY a
ORDER BY a ASC;

SELECT
    a,
    b
FROM tab_00717
GROUP BY
    a,
    b
ORDER BY
    a ASC,
    b ASC;

SELECT sum(length(a))
FROM tab_00717
GROUP BY
    b,
    b || '_';

SELECT length(b) AS l
FROM tab_00717
GROUP BY
    l,
    l + 1;

SELECT length(b) AS l
FROM tab_00717
GROUP BY
    l,
    l + 1,
    l + 2;

SELECT length(b) AS l
FROM tab_00717
GROUP BY
    l,
    l + 1,
    l + 2,
    l + 3;

SELECT length(b) AS l
FROM tab_00717
GROUP BY
    l,
    l + 1,
    l + 2,
    l + 3,
    l + 4;

SELECT length(b) AS l
FROM tab_00717
GROUP BY
    l,
    l + 1,
    l + 2,
    l + 3,
    l + 4,
    l + 5;

SELECT
    a,
    length(b) AS l
FROM tab_00717
GROUP BY
    a,
    l,
    l + 1
ORDER BY a ASC;

SELECT
    b,
    length(b) AS l
FROM tab_00717
GROUP BY
    b,
    l,
    l + 1
ORDER BY b ASC;

SELECT
    a,
    b,
    length(b) AS l
FROM tab_00717
GROUP BY
    a,
    b,
    l,
    l + 1
ORDER BY
    a ASC,
    b ASC;