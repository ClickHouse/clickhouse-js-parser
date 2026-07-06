-- { echo }
SET intersect_default_mode = 'DISTINCT';

SET except_default_mode = 'DISTINCT';

SELECT 1
INTERSECT
SELECT 1;

SELECT 2
INTERSECT
SELECT 1;

SELECT 1
EXCEPT
SELECT 1;

SELECT 2
EXCEPT
SELECT 1;

SELECT 5
FROM numbers(20)
INTERSECT
SELECT number
FROM numbers(5, 5);

SELECT number
FROM numbers(10)
EXCEPT
SELECT number
FROM numbers(5);

SELECT
    number,
    number + 10
FROM numbers(12)
EXCEPT
SELECT
    number + 5,
    number + 15
FROM numbers(10);

SELECT 1
EXCEPT
SELECT 2
INTERSECT
SELECT 1;

SELECT 1
EXCEPT
SELECT 2
INTERSECT
SELECT 2;

(SELECT 1
INTERSECT
SELECT 1)
EXCEPT
SELECT 2;

(SELECT 1
INTERSECT
SELECT 1)
EXCEPT
SELECT 1;

((SELECT 1
INTERSECT
SELECT 1)
EXCEPT
SELECT 2
INTERSECT
SELECT 1)
EXCEPT
SELECT 3
INTERSECT
SELECT 1;

((SELECT 1
INTERSECT
SELECT 1)
EXCEPT
SELECT 2
INTERSECT
SELECT 1)
EXCEPT
SELECT 3
INTERSECT
SELECT 2;

(((SELECT 1
INTERSECT
SELECT 1)
EXCEPT
SELECT 2
INTERSECT
SELECT 1)
EXCEPT
SELECT 3
INTERSECT
SELECT 2)
EXCEPT
SELECT 1;

SELECT number % 3
FROM numbers(10)
EXCEPT
SELECT 1;

((SELECT number
FROM numbers(100)
INTERSECT
SELECT number
FROM numbers(20, 60))
EXCEPT
SELECT number
FROM numbers(30, 20))
EXCEPT
SELECT number
FROM numbers(60, 20);

SELECT *
FROM (
        SELECT 1
INTERSECT
        SELECT 1
    );

WITH (
        SELECT number
        FROM numbers(10)
INTERSECT
        SELECT 5
    ) AS a

SELECT a * 10;

WITH (
        SELECT 5
EXCEPT
        SELECT 1
    ) AS a

SELECT a
EXCEPT
WITH (
        SELECT 5
EXCEPT
        SELECT 1
    ) AS a

SELECT 5;

WITH (
        SELECT number
        FROM numbers(10)
INTERSECT
        SELECT 5
    ) AS a

SELECT a
INTERSECT
WITH (
        SELECT number
        FROM numbers(10)
INTERSECT
        SELECT 5
    ) AS a

SELECT 1;

WITH (
        SELECT number
        FROM numbers(10)
INTERSECT
        SELECT 5
    ) AS a

SELECT a
EXCEPT
WITH (
        SELECT number
        FROM numbers(10)
INTERSECT
        SELECT 5
    ) AS a

SELECT 1;

SELECT count()
FROM (
        SELECT number
        FROM numbers(10)
EXCEPT
        SELECT 5
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers(1000000)
INTERSECT
        SELECT number
        FROM numbers(200000, 600000)
    );

SELECT count()
FROM (
((        SELECT number
        FROM numbers(100)
INTERSECT
        SELECT number
        FROM numbers(20, 60))
EXCEPT
        SELECT number
        FROM numbers(30, 20))
EXCEPT
        SELECT number
        FROM numbers(60, 20)
    );

SELECT count()
FROM (
(((        SELECT number
        FROM numbers(100)
INTERSECT
        SELECT number
        FROM numbers(20, 60))
EXCEPT
        SELECT number
        FROM numbers(30, 20))
EXCEPT
        SELECT number
        FROM numbers(60, 20))
        UNION ALL
        SELECT number
        FROM numbers(100, 10)
    );

SELECT count()
FROM (
((        SELECT number
        FROM numbers(1000000)
INTERSECT
        SELECT number
        FROM numbers(200000, 600000))
EXCEPT
        SELECT number
        FROM numbers(300000, 200000))
EXCEPT
        SELECT number
        FROM numbers(600000, 200000)
    );

SELECT count()
FROM (
        SELECT 1
INTERSECT
        SELECT 1
    )
LIMIT 100;

SELECT count()
FROM (
        SELECT 1
EXCEPT
        SELECT 2
    )
LIMIT 100;

WITH (
        SELECT count()
        FROM (
(                SELECT 1
                UNION DISTINCT
                SELECT 2)
EXCEPT
                SELECT 1
            )
    ) AS max

SELECT count()
FROM (
        SELECT 1
        UNION ALL
        SELECT max
    )
LIMIT 100;

SELECT 1
UNION ALL
(SELECT 1
INTERSECT
SELECT 1);

SELECT 1
UNION ALL
(SELECT 1
INTERSECT
SELECT 2);

SELECT *
FROM (
((        SELECT 1
        UNION ALL
        SELECT 2
        UNION ALL
        SELECT 3
        UNION ALL
        SELECT 4)
EXCEPT
        SELECT 3)
        UNION ALL
        SELECT 5
    )
ORDER BY 1 ASC;

SELECT *
FROM (
        SELECT 1
        UNION ALL
        SELECT 2
        UNION ALL
        SELECT 3
        UNION ALL
(        SELECT 4
INTERSECT
        SELECT 3)
        UNION ALL
        SELECT 5
    )
ORDER BY 1 ASC;

SELECT *
FROM (
(        SELECT 1
        UNION ALL
        SELECT 2
        UNION ALL
        SELECT 3
        UNION ALL
(        SELECT 4
INTERSECT
        SELECT 3)
        UNION ALL
        SELECT 5)
EXCEPT
        SELECT 1
    )
ORDER BY 1 ASC;

SELECT 1
INTERSECT
(SELECT 1
EXCEPT
SELECT 2);

((SELECT 1
UNION ALL
SELECT 2)
EXCEPT
((SELECT 2
EXCEPT
SELECT 1)
UNION ALL
SELECT 1))
EXCEPT
SELECT 4;

SELECT 1
INTERSECT
SELECT count()
FROM (
(        SELECT 1
EXCEPT
        SELECT 2
INTERSECT
        SELECT 2)
        UNION ALL
        SELECT 1
    );

EXPLAIN SYNTAX
SELECT 1
INTERSECT
SELECT 1;

EXPLAIN SYNTAX
SELECT 1
EXCEPT
SELECT 1;

EXPLAIN SYNTAX
((SELECT 1
UNION ALL
SELECT 2)
EXCEPT
((SELECT 2
EXCEPT
SELECT 1)
UNION ALL
SELECT 1))
EXCEPT
SELECT 4;

SET limit = '1';

(SELECT 1)
INTERSECT
SELECT 1;