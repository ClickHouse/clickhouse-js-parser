SELECT *
FROM
    numbers(10, 10) AS `left`
RIGHT JOIN (
        SELECT
            number,
            number AS x,
            'str' || number AS str,
            arrayJoin(range(number)) AS i
        FROM numbers(10)
    ) AS `right`
    ON `left`.number = `right`.number
ORDER BY
    `right`.number ASC,
    i ASC
SETTINGS enable_lazy_columns_replication = '1';