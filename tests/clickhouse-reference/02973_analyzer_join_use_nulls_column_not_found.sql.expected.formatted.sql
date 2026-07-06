SET join_use_nulls = '1';

SELECT '--';

SELECT c
FROM (
        SELECT d2.c
        FROM
            (
                SELECT
                    1 AS a,
                    2 AS b
            ) AS d1
        FULL JOIN (
                SELECT
                    1 AS a,
                    3 AS c
            ) AS d2
            ON d1.a = d2.a
    );

WITH d1 AS (
    SELECT
        1 AS a,
        2 AS b
),

d2 AS (
    SELECT
        1 AS a,
        3 AS c
),

joined AS (
    SELECT
        d1.*,
        d2.c
    FROM
        d1
    INNER JOIN d2
        ON d1.a = d2.a
)

SELECT c
FROM joined;

WITH a AS (
    SELECT
        0 AS key,
        'a' AS acol
),

b AS (
    SELECT 2 AS key
)

SELECT a.key
FROM
    b
LEFT JOIN a
    ON 1
LEFT JOIN a AS a1
    ON 1;

WITH a AS (
    SELECT
        0 AS key,
        'a' AS acol
),

b AS (
    SELECT 2 AS key
)

SELECT
    a.acol,
    a1.acol
FROM
    b
LEFT JOIN a
    ON a.key = b.key
LEFT JOIN a AS a1
    ON a1.key = a.key;

WITH a AS (
    SELECT
        0 AS key,
        'a' AS acol
),

b AS (
    SELECT 2 AS key
)

SELECT
    a.acol,
    a1.acol
FROM
    b
FULL JOIN a
    ON a.key = b.key
FULL JOIN a AS a1
    ON a1.key = a.key
ORDER BY 1 ASC
SETTINGS join_use_nulls = '0';

WITH a AS (
    SELECT
        0 AS key,
        'a' AS acol
),

b AS (
    SELECT 2 AS key
)

SELECT
    a.acol,
    a1.acol
FROM
    b
FULL JOIN a
    ON a.key = b.key
FULL JOIN a AS a1
    ON a1.key = a.key
ORDER BY 1 ASC;