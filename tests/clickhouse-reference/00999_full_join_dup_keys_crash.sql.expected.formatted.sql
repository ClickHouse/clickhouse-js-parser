SET join_use_nulls = '0';

SELECT *
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
FULL JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.a = bar.b
    AND foo.b = bar.b
ORDER BY
    foo.a ASC,
    foo.b ASC,
    bar.a ASC,
    bar.b ASC;

SELECT *
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
RIGHT JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.a = bar.b
    AND foo.b = bar.b
ORDER BY
    foo.a ASC,
    foo.b ASC,
    bar.a ASC,
    bar.b ASC;

SELECT *
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
FULL JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.b = bar.a
    AND foo.b = bar.b
ORDER BY
    foo.a ASC,
    foo.b ASC,
    bar.a ASC,
    bar.b ASC;

SELECT *
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
RIGHT JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.b = bar.a
    AND foo.b = bar.b
ORDER BY
    foo.a ASC,
    foo.b ASC,
    bar.a ASC,
    bar.b ASC;

SELECT foo.a
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
FULL JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.a = bar.b
    AND foo.b = bar.b
ORDER BY foo.a ASC;

SELECT foo.a
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
RIGHT JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.a = bar.b
    AND foo.b = bar.b
ORDER BY foo.a ASC;

SELECT foo.a
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
FULL JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.b = bar.a
    AND foo.b = bar.b
ORDER BY foo.a ASC;

SELECT foo.a
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
RIGHT JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.b = bar.a
    AND foo.b = bar.b
ORDER BY foo.a ASC;

SELECT bar.a
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
FULL JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.a = bar.b
    AND foo.b = bar.b
ORDER BY bar.a ASC;

SELECT bar.a
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
RIGHT JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.a = bar.b
    AND foo.b = bar.b
ORDER BY bar.a ASC;

SELECT bar.a
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
FULL JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.b = bar.a
    AND foo.b = bar.b
ORDER BY bar.a ASC;

SELECT bar.a
FROM
    (
        SELECT
            1 AS a,
            2 AS b
    ) AS foo
RIGHT JOIN (
        SELECT
            1 AS a,
            2 AS b
    ) AS bar
    ON foo.b = bar.a
    AND foo.b = bar.b
ORDER BY bar.a ASC;

SET join_use_nulls = '1';