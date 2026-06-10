SET join_algorithm = 'full_sorting_merge';

SELECT *
FROM
    (
        SELECT 1 AS key
    ) AS t1
INNER JOIN (
        SELECT 1 AS key
    ) AS t2
    ON t1.key = t2.key
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT 1 AS key
    ) AS t1
INNER JOIN (
        SELECT 1 AS key
    ) AS t2
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT CAST('1' AS UInt32) AS key
    ) AS t1
FULL JOIN (
        SELECT CAST('1' AS Nullable(UInt32)) AS key
    ) AS t2
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT CAST('1' AS UInt32) AS key
    ) AS t1
FULL JOIN (
        SELECT NULL::Nullable(UInt32) AS key
    ) AS t2
    USING (key)
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT CAST('1' AS Int32) AS key
    ) AS t1
INNER JOIN (
        SELECT CAST('1' AS UInt32) AS key
    ) AS t2
    ON t1.key = t2.key
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT CAST('-1' AS Nullable(Int32)) AS key
    ) AS t1
FULL JOIN (
        SELECT CAST('4294967295' AS UInt32) AS key
    ) AS t2
    ON t1.key = t2.key
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT 'a'::LowCardinality(String) AS key
    ) AS t1
INNER JOIN (
        SELECT 'a'::String AS key
    ) AS t2
    ON t1.key = t2.key
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT 'a'::LowCardinality(Nullable(String)) AS key
    ) AS t1
INNER JOIN (
        SELECT 'a'::String AS key
    ) AS t2
    ON t1.key = t2.key
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT 'a'::LowCardinality(Nullable(String)) AS key
    ) AS t1
INNER JOIN (
        SELECT 'a'::Nullable(String) AS key
    ) AS t2
    ON t1.key = t2.key
ORDER BY key ASC;

SELECT *
FROM
    (
        SELECT 'a'::LowCardinality(String) AS key
    ) AS t1
INNER JOIN (
        SELECT 'a'::LowCardinality(String) AS key
    ) AS t2
    ON t1.key = t2.key
ORDER BY key ASC;

SELECT 5 = count()
FROM
    (
        SELECT number AS a
        FROM numbers(5)
    ) AS t1
LEFT JOIN (
        SELECT number AS b
        FROM numbers(5)
        WHERE number > 100
    ) AS t2
    ON t1.a = t2.b
ORDER BY 1 ASC;

SELECT 5 = count()
FROM
    (
        SELECT number AS a
        FROM numbers(5)
        WHERE number > 100
    ) AS t1
RIGHT JOIN (
        SELECT number AS b
        FROM numbers(5)
    ) AS t2
    ON t1.a = t2.b
ORDER BY 1 ASC;

SELECT sum(ignore(*) + 1)
FROM
    (
        SELECT NULL::LowCardinality(Nullable(String)) AS key
    ) AS t1
FULL JOIN (
        SELECT NULL::LowCardinality(Nullable(String)) AS key
    ) AS t2
    ON t1.key = t2.key;

SELECT sum(ignore(*) + 1)
FROM
    (
        SELECT NULL::Nullable(String) AS key
    ) AS t1
FULL JOIN (
        SELECT NULL::LowCardinality(Nullable(String)) AS key
    ) AS t2
    ON t1.key = t2.key;

SELECT sum(ignore(*) + 1)
FROM
    (
        SELECT NULL::LowCardinality(Nullable(String)) AS key
    ) AS t1
FULL JOIN (
        SELECT NULL::Nullable(String) AS key
    ) AS t2
    ON t1.key = t2.key;

SELECT sum(ignore(*) + 1)
FROM
    (
        SELECT NULL::LowCardinality(Nullable(String)) AS key
    ) AS t1
FULL JOIN (
        SELECT 'a'::String AS key
    ) AS t2
    ON t1.key = t2.key;

SELECT sum(ignore(*) + 1)
FROM
    (
        SELECT 'a'::String AS key
    ) AS t1
FULL JOIN (
        SELECT NULL::LowCardinality(Nullable(String)) AS key
    ) AS t2
    ON t1.key = t2.key;