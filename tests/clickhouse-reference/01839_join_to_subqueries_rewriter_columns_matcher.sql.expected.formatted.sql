SELECT if(a.test = 'a', b.test, c.test) AS `a.test`
FROM
    (
        SELECT
            1 AS id,
            'a' AS test
    ) AS a
LEFT JOIN (
        SELECT
            1 AS id,
            'b' AS test
    ) AS b
    ON b.id = a.id
LEFT JOIN (
        SELECT
            1 AS id,
            'c' AS test
    ) AS c
    ON c.id = a.id;

SELECT COLUMNS('test')
FROM
    (
        SELECT
            1 AS id,
            'a' AS test
    ) AS a
LEFT JOIN (
        SELECT
            1 AS id,
            'b' AS test
    ) AS b
    ON b.id = a.id
LEFT JOIN (
        SELECT
            1 AS id,
            'c' AS test
    ) AS c
    ON c.id = a.id;