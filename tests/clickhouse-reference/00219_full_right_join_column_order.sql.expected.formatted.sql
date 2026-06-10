SET any_join_distinct_right_table_keys = '1';

SELECT
    a,
    b
FROM
    (
        SELECT
            1 AS a,
            2000 AS b
    ) AS js1
ANY RIGHT JOIN (
        SELECT
            2 AS a,
            3000 AS b
    ) AS js2
    USING (a, b)
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b
FROM
    (
        SELECT
            1 AS a,
            2000 AS b
    ) AS js1
ANY RIGHT JOIN (
        SELECT
            2 AS a,
            3000 AS b
    ) AS js2
    USING (b, a)
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b
FROM
    (
        SELECT
            1 AS a,
            2000 AS b
    ) AS js1
ANY RIGHT JOIN (
        SELECT
            2 AS a,
            3000 AS b
        UNION ALL
        SELECT
            1 AS a,
            2000 AS b
    ) AS js2
    USING (a, b)
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b
FROM
    (
        SELECT
            1 AS a,
            2000 AS b
    ) AS js1
ANY RIGHT JOIN (
        SELECT
            2 AS a,
            3000 AS b
        UNION ALL
        SELECT
            1 AS a,
            2000 AS b
    ) AS js2
    USING (b, a)
ORDER BY
    a ASC,
    b ASC;