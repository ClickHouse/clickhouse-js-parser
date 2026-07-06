SELECT
    round(countIf(rating = 5) - countIf(rating < 5), 4) AS nps,
    dense_rank() OVER (ORDER BY nps DESC) AS rank
FROM (
        SELECT
            number AS rating,
            number % 3 AS rest_id
        FROM numbers(10)
    )
GROUP BY rest_id
ORDER BY rank ASC;