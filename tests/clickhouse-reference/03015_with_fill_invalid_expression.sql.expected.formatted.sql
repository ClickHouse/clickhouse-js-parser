SELECT
    number AS x,
    number + 1 AS y
FROM numbers(5)
WHERE number % 3 = 1
ORDER BY
    y ASC,
    x ASC WITH FILL FROM 1 TO 4,
    y ASC WITH FILL FROM 2 TO 5; -- {serverError INVALID_WITH_FILL_EXPRESSION}