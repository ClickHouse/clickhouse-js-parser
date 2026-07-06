SELECT x
FROM (
        SELECT 5 AS x
    )
ORDER BY
    -x ASC,
    x ASC WITH FILL FROM 1 TO 10;