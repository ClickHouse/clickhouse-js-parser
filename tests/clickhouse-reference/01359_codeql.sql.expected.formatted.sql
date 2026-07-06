-- In previous ClickHouse versions, the multiplications was made in a wrong type leading to overflow.
SELECT round(avgWeighted(x, y))
FROM (
        SELECT
            4294967295 AS x,
            1000000000 AS y
        UNION ALL
        SELECT
            1 AS x,
            1 AS y
    );