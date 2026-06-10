DROP TABLE IF EXISTS t2;

CREATE TABLE t2
(
    s String,
    x Array(UInt8),
    k UInt64
)
ENGINE = Join(`ANY`, `LEFT`, k);

INSERT INTO t2;

INSERT INTO t2 (k, s);

INSERT INTO t2 (x, k);

SELECT
    k,
    s
FROM
    (
        SELECT number AS k
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    USING (k);

SELECT
    s,
    x
FROM
    (
        SELECT number AS k
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    USING (k);

SELECT
    x,
    s,
    k
FROM
    (
        SELECT number AS k
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    USING (k);

SELECT
    1,
    x,
    2,
    s,
    3,
    k,
    4
FROM
    (
        SELECT number AS k
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    USING (k);

SELECT
    t1.k,
    t1.s,
    t2.x
FROM
    (
        SELECT
            number AS k,
            'a' AS s
        FROM numbers(2)
        GROUP BY number
        WITH TOTALS
        ORDER BY number ASC
    ) AS t1
ANY LEFT JOIN t2 AS t2
    USING (k);

DROP TABLE t2;