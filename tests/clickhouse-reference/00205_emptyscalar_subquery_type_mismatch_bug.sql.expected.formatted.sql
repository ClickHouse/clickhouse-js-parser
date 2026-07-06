-- Bug reproduction form #25411
WITH a AS (
    SELECT (
            SELECT 1
            WHERE 0
        ) AS b
)

SELECT 1
FROM
    `system`.one
CROSS JOIN a
WHERE a.b = 0;

-- Reported query
DROP TABLE IF EXISTS t_q1ht4gq_5;

CREATE TABLE t_q1ht4gq_5
(
    c_zeij INTEGER NOT NULL,
    c_fehk75l TEXT,
    c_jz TEXT,
    c_wynzuek TEXT,
    c_nkt INTEGER NOT NULL,
    c_g TEXT,
    c_mc2 TEXT,
    PRIMARY KEY(c_nkt)
)
ENGINE = MergeTree();

WITH cte_0 AS (
    SELECT
        subq_0.c6 AS c2,
        multiIf(0 != 0, (
            SELECT c_zeij
            FROM t_q1ht4gq_5
            ORDER BY c_zeij ASC
            LIMIT 1
            OFFSET 1
        ) + subq_0.c4, (
            SELECT c_zeij
            FROM t_q1ht4gq_5
            ORDER BY c_zeij ASC
            LIMIT 1
            OFFSET 1
        ) + subq_0.c4) AS c4
    FROM (
            SELECT
                ref_0.c_nkt AS c4,
                ref_0.c_nkt AS c6
            FROM t_q1ht4gq_5 AS ref_0
        ) AS subq_0
)

SELECT ref_12.c_zeij AS c3
FROM t_q1ht4gq_5 AS ref_12
WHERE ref_12.c_jz NOT IN (
        SELECT ref_14.c_mc2 AS c0
        FROM
            t_q1ht4gq_5 AS ref_14
        CROSS JOIN cte_0 AS ref_15
        WHERE ref_15.c4 > ref_15.c2
    );