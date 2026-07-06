DROP TABLE IF EXISTS t2;

CREATE TABLE t2
(
    k UInt64,
    s String
)
ENGINE = Join(`ANY`, `LEFT`, k);

INSERT INTO t2;

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
    USING (k)
ORDER BY k ASC;

INSERT INTO t2;

SELECT
    k,
    js1.s,
    t2.s
FROM
    (
        SELECT
            number AS k,
            number AS s
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    USING (k)
ORDER BY k ASC;

SELECT
    k,
    t2.k,
    js1.s,
    t2.s
FROM
    (
        SELECT
            number AS k,
            number AS s
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    USING (k)
ORDER BY k ASC;

SELECT
    k,
    js1.s,
    t2.s
FROM
    (
        SELECT
            toUInt64(number / 3) AS k,
            sum(number) AS s
        FROM numbers(10)
        GROUP BY toUInt64(number / 3)
        WITH TOTALS
    ) AS js1
ANY LEFT JOIN t2
    USING (k)
ORDER BY k ASC;

SELECT
    k,
    js1.s,
    t2.s
FROM
    (
        SELECT
            number AS k,
            number AS s
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    ON js1.k = t2.k
ORDER BY k ASC;

SELECT
    k,
    t2.k,
    js1.s,
    t2.s
FROM
    (
        SELECT
            number AS k,
            number AS s
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    ON js1.k = t2.k
ORDER BY k ASC;

SELECT
    k,
    js1.s,
    t2.s
FROM
    (
        SELECT
            number AS k,
            number AS s
        FROM `system`.numbers
        LIMIT 10
    ) AS js1
ANY LEFT JOIN t2
    ON js1.k = t2.k
    OR js1.s = t2.k
ORDER BY k ASC; -- { serverError NOT_IMPLEMENTED, INCOMPATIBLE_TYPE_OF_JOIN }

DROP TABLE t2;