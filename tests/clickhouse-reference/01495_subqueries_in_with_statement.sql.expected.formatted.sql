DROP TABLE IF EXISTS test1;

CREATE TABLE test1
(
    i int,
    j int
)
ENGINE = Log();

INSERT INTO test1;

WITH test1 AS (
    SELECT *
    FROM numbers(5)
)

SELECT *
FROM test1;

WITH test1 AS (
    SELECT
        i + 1,
        j + 1
    FROM test1
)

SELECT *
FROM test1;

WITH test1 AS (
    SELECT
        i + 1,
        j + 1
    FROM test1
)

SELECT *
FROM (
        SELECT *
        FROM test1
    );

SELECT *
FROM
    (
        WITH test1 AS (
            SELECT toInt32(*) AS i
            FROM numbers(5)
        )

        SELECT *
        FROM test1
    ) AS l
ANY INNER JOIN test1 AS r
    ON l.i = r.i;

WITH test1 AS (
    SELECT
        i + 1,
        j + 1
    FROM test1
)

SELECT
    toInt64(4) AS i,
    toInt64(5) AS j
FROM numbers(3)
WHERE (i, j) IN (test1);

SELECT '---------------------------';

SET empty_result_for_aggregation_by_empty_set = '0';

WITH test1 AS (
    SELECT number - 1 AS n
    FROM numbers(42)
)

SELECT max(n + 1) + 1 AS z
FROM test1;

WITH test1 AS (
    SELECT number - 1 AS n
    FROM numbers(42)
)

SELECT max(n + 1) + 1 AS z
FROM
    test1
INNER JOIN test1 AS x
    USING (n)
HAVING z - 1 = (
        SELECT min(n - 1) + 41
        FROM test1
    ) + 2;

WITH test1 AS (
    SELECT number - 1 AS n
    FROM numbers(4442)
    ORDER BY n ASC
    LIMIT 100
)

SELECT max(n)
FROM test1
WHERE n = 422;

WITH test1 AS (
    SELECT number - 1 AS n
    FROM numbers(4442)
    ORDER BY n ASC
    LIMIT 100
)

SELECT max(n)
FROM test1
WHERE n = 42;

DROP TABLE IF EXISTS with_test;

CREATE TABLE with_test
ENGINE = Memory() AS
SELECT CAST(number - 1 AS Nullable(Int64)) AS n
FROM numbers(10000);

WITH test1 AS (
    SELECT n
    FROM with_test
    WHERE n <= 40
)

SELECT max(n + 1) + 1 AS z
FROM
    test1
INNER JOIN test1 AS x
    USING (n)
HAVING max(n + 1) + 1 - 1 = (
        SELECT min(n - 1) + 41
        FROM test1
    ) + 2;

WITH test1 AS (
    SELECT n
    FROM with_test
    WHERE n <= 40
)

SELECT max(n + 1) + 1 AS z
FROM
    test1
INNER JOIN test1 AS x
    USING (n)
HAVING z - 1 = (
        SELECT min(n - 1) + 41
        FROM test1
    ) + 2;

WITH test1 AS (
    SELECT n
    FROM with_test
    ORDER BY n ASC
    LIMIT 100
)

SELECT max(n)
FROM test1
WHERE n = 422;

WITH test1 AS (
    SELECT n
    FROM with_test
    ORDER BY n ASC
    LIMIT 100
)

SELECT max(n)
FROM test1
WHERE n = 42;

WITH test1 AS (
    SELECT n
    FROM with_test
    WHERE n = 42
    ORDER BY n ASC
    LIMIT 100
)

SELECT max(n)
FROM test1
WHERE n = 42;

WITH test1 AS (
    SELECT n
    FROM with_test
    WHERE n = 42
        OR 1 = 1
    ORDER BY n ASC
    LIMIT 100
)

SELECT max(n)
FROM test1
WHERE n = 42;

WITH test1 AS (
    SELECT
        n,
        NULL AS b
    FROM with_test
    WHERE n = 42
        OR b IS NULL
    ORDER BY n ASC
    LIMIT 100
)

SELECT max(n)
FROM test1
WHERE n = 42;

WITH test1 AS (
    SELECT
        n,
        NULL AS b
    FROM with_test
    WHERE b IS NULL
)

SELECT max(n)
FROM test1
WHERE n = 42;

WITH test1 AS (
    SELECT
        n,
        NULL AS b
    FROM with_test
    WHERE b IS NULL
        OR 1 = 1
)

SELECT max(n)
FROM test1
WHERE n = 45;

WITH test1 AS (
    SELECT
        n,
        NULL AS b
    FROM with_test
    WHERE b IS NULL
        AND n = 42
)

SELECT max(n)
FROM test1
WHERE n = 45;

WITH test1 AS (
    SELECT
        n,
        NULL AS b
    FROM with_test
    WHERE 1 = 1
        AND n = 42
    ORDER BY n ASC
)

SELECT max(n)
FROM test1
WHERE n = 45;

WITH test1 AS (
    SELECT
        n,
        NULL AS b,
        n + 1 AS m
    FROM with_test
    WHERE 1 = 0
        OR n = 42
    ORDER BY n ASC
    LIMIT 4
)

SELECT max(n) AS m
FROM test1
WHERE test1.m = 43
HAVING max(n) = 42;

WITH test1 AS (
    SELECT
        n,
        NULL AS b,
        n + 1 AS m
    FROM with_test
    WHERE n = 42
    ORDER BY n ASC
    LIMIT 4
)

SELECT max(n) AS m
FROM test1
WHERE b IS NULL
    AND test1.m = 43
HAVING m = 42
LIMIT 4;

WITH test1 AS (
    SELECT
        n,
        NULL AS b,
        n + 1 AS m
    FROM with_test
    WHERE n = 42
    ORDER BY n ASC
    LIMIT 4
),

test2 AS (
    SELECT
        n + 1 AS x,
        n - 1 AS y
    FROM test1
),

test3 AS (
    SELECT x * y AS z
    FROM test2
)

SELECT z + 1 AS q
FROM test3;

DROP TABLE with_test;