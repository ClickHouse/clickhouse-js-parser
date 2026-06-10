-- { echo }
-- no clash name
SELECT
    c + 1,
    Z.c + 1
FROM
    (
        SELECT 10 AS a
    ) AS X
CROSS JOIN (
        SELECT 20 AS b
    ) AS Y
CROSS JOIN (
        SELECT 30 AS c
    ) AS Z;

-- alias clash
SELECT
    a + 1 AS c,
    Z.c + 1
FROM
    (
        SELECT 10 AS a
    ) AS X
CROSS JOIN (
        SELECT 20 AS b
    ) AS Y
CROSS JOIN (
        SELECT 30 AS c
    ) AS Z;

-- column clash
SELECT
    X.c + 1 AS c,
    Z.c + 1
FROM
    (
        SELECT 10 AS c
    ) AS X
CROSS JOIN (
        SELECT 20 AS b
    ) AS Y
CROSS JOIN (
        SELECT 30 AS c
    ) AS Z;

SELECT
    X.a + 1 AS a,
    Y.a + 1 AS Y_a,
    Z.a + 1 AS Z_a,
    Y.b + 1 AS b,
    Z.b + 1 AS Z_b
FROM
    (
        SELECT 10 AS a
    ) AS X
CROSS JOIN (
        SELECT
            20 AS a,
            21 AS b
    ) AS Y
CROSS JOIN (
        SELECT
            30 AS a,
            31 AS b,
            32 AS c
    ) AS Z;