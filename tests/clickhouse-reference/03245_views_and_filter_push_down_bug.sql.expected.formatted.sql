SELECT *
FROM view(    SELECT
        id,
        toDateTime(date) AS date
    FROM view(        SELECT
            1 AS id,
            '2024-05-02' AS date))
WHERE date = '2024-05-02';