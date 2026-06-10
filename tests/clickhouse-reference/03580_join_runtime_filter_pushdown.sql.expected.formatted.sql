SET enable_analyzer = '1';

SELECT `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT *
                FROM
                    (
                        SELECT
                            a.number AS a_number,
                            b.number AS b_number
                        FROM
                            numbers(10) AS a
                        INNER JOIN numbers(10) AS b
                            ON a.number % 2 = b.number % 3
                    ) AS ab
                INNER JOIN numbers(10) AS c
                    ON b_number = c.number + 2
                SETTINGS enable_join_runtime_filters = '1'
            ))
    );