-- Regression for PartialSortingTransform optimization that requires at least 1500 rows.
SELECT *
FROM (
        SELECT *
        FROM (
                SELECT
                    0 AS a,
                    toNullable(number) AS b,
                    toString(number) AS c
                FROM numbers(1000000.)
            )
        ORDER BY
            a DESC,
            b DESC,
            c ASC
        LIMIT 1500
    )
LIMIT 10;

SELECT number
FROM (
        SELECT
            number,
            1 AS k
        FROM numbers(100000)
        ORDER BY
            k ASC,
            number DESC
        LIMIT 1023
        OFFSET 1025
    )
LIMIT 5;