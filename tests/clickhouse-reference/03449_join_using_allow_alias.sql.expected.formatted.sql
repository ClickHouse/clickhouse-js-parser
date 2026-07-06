SET enable_analyzer = '1';

-- { echo On }
SELECT *
FROM
    numbers(1) AS l
INNER JOIN `system`.one AS r
    USING (number AS dummy);

SELECT *
FROM
    `system`.one AS l
INNER JOIN numbers(1) AS r
    USING (dummy AS number);

SELECT *
FROM
    numbers(2) AS l
INNER JOIN (
        SELECT number + 1 AS dummy
        FROM numbers(1)
    ) AS r
    USING (number AS dummy);

SELECT *
FROM
    (
        SELECT number + 1 AS dummy
        FROM numbers(1)
    ) AS l
INNER JOIN numbers(2) AS r
    USING (dummy AS number);