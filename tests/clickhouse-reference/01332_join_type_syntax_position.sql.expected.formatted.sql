SELECT *
FROM
    numbers(1) AS t1
LEFT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
RIGHT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ANY LEFT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ANY RIGHT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
SEMI LEFT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
SEMI RIGHT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ANTI LEFT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ANTI RIGHT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ASOF INNER JOIN numbers(1) AS t2
    USING (number); -- { serverError NOT_IMPLEMENTED }

SELECT *
FROM
    numbers(1) AS t1
ASOF LEFT JOIN numbers(1) AS t2
    USING (number); -- { serverError NOT_IMPLEMENTED }

-- legacy
SELECT *
FROM
    numbers(1) AS t1
ALL LEFT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ALL RIGHT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ANY LEFT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ANY RIGHT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
SEMI LEFT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
SEMI RIGHT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ANTI LEFT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ANTI RIGHT JOIN numbers(1) AS t2
    USING (number);

SELECT *
FROM
    numbers(1) AS t1
ASOF LEFT JOIN numbers(1) AS t2
    USING (number); -- { serverError NOT_IMPLEMENTED }