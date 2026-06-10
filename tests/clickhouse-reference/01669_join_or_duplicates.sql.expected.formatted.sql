SELECT
    '1 left',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
LEFT JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(1)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT
    '5 left',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
LEFT JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(5)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT
    '15 left',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
LEFT JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(15)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT
    '16 left',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
LEFT JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(16)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT
    '17 left',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
LEFT JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(17)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT
    '17 any left',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
ANY LEFT JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(17)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT
    '17 right',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
RIGHT JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(17)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT
    '17 any right',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
ANY RIGHT JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(17)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT
    '17 full',
    *
FROM
    (
        SELECT
            1 AS x,
            2 AS y
    ) AS t1
FULL JOIN (
        SELECT
            1 AS xx,
            2 AS yy
        FROM numbers(17)
    ) AS t2
    ON x = xx
    OR y = yy;

SELECT count(1)
FROM (
        SELECT *
        FROM
            (
                SELECT
                    1 AS x,
                    2 AS y
            ) AS t1
        LEFT JOIN (
                SELECT
                    1 AS xx,
                    2 AS yy
                FROM numbers(555)
            ) AS t2
            ON x = xx
            OR y = yy
    );

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            number AS c
        FROM numbers(2)
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            number AS c
        FROM numbers(2)
    ) AS t2
    ON t1.c = t2.c
    OR t1.a = t2.a
ORDER BY
    t1.c ASC,
    t2.c ASC;

SELECT *
FROM
    (
        SELECT
            'a' AS a,
            number AS c
        FROM numbers(2)
    ) AS t1
INNER JOIN (
        SELECT
            'a' AS a,
            number AS c
        FROM numbers(2)
    ) AS t2
    ON t1.a = t2.a
    OR t1.c = t2.c
ORDER BY
    t1.c ASC,
    t2.c ASC;