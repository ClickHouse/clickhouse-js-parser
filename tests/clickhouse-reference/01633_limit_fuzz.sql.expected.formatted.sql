SELECT
    number,
    1 AS k
FROM numbers(100000)
ORDER BY
    k ASC,
    number ASC
LIMIT 1023
OFFSET 1025
FORMAT Values;