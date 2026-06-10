SELECT n
FROM (
        SELECT number AS n
        FROM `system`.numbers
        LIMIT 1000000
    )
ORDER BY
    n ASC,
    n ASC,
    n ASC,
    n ASC,
    n ASC,
    n ASC,
    n ASC,
    n ASC,
    n ASC,
    n ASC
LIMIT 1
OFFSET 1000000;