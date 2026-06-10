SELECT id
FROM
    (
        SELECT 1 AS id
        UNION ALL
        SELECT NULL
        UNION ALL
        SELECT NULL
    ) AS js1
ALL FULL JOIN (
        SELECT 1 AS id
        UNION ALL
        SELECT NULL
        UNION ALL
        SELECT NULL
    ) AS js2
    USING (id)
ORDER BY id ASC;

SELECT '---';

SELECT *
FROM
    (
        SELECT NULL AS x
    ) AS js1
INNER JOIN (
        SELECT NULL AS x
    ) AS js2
    USING (x);

SELECT *
FROM
    (
        SELECT NULL AS x
    ) AS js1
FULL JOIN (
        SELECT NULL AS x
    ) AS js2
    USING (x);