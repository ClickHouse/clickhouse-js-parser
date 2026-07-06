CREATE TABLE t0
(
    c0 Int,
    c1 Int
)
ENGINE = Memory();

SELECT 1
FROM
    t0 AS l
INNER JOIN t0 AS m
    ON true
ANY RIGHT JOIN t0 AS r
    ON l.c0 + l.c1 = r.c1
WHERE 1 IS NULL;