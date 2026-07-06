SELECT
    -number % 2 AS i,
    toDecimal32(number % 20, 3) AS j
FROM numbers(600)
ORDER BY
    i ASC,
    j ASC;