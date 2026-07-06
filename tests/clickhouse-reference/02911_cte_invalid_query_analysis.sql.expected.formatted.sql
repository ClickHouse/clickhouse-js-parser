DROP TABLE IF EXISTS t0;

DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t3;

CREATE TABLE t0
(
    pkey UInt32,
    c1 UInt32,
    PRIMARY KEY(pkey)
)
ENGINE = MergeTree();

CREATE TABLE t1
(
    vkey UInt32,
    PRIMARY KEY(vkey)
)
ENGINE = MergeTree();

CREATE TABLE t3
(
    c17 String,
    PRIMARY KEY(c17)
)
ENGINE = MergeTree();

INSERT INTO t1;

WITH cte_1 AS (
    SELECT
        subq_1.c_5_c1698_16 AS c_2_c1702_3,
        subq_1.c_5_c1694_12 AS c_2_c1703_4
    FROM (
            SELECT
                covarPop(0, 74) AS c_5_c1686_4,
                sumWithOverflow(0) AS c_5_c1694_12,
                covarPop(-53.64, 92.63) AS c_5_c1698_16
            FROM t3 AS ref_8
            GROUP BY ref_8.c17
        ) AS subq_1
)

SELECT
    ref_15.c_2_c1703_4 AS c_2_c1723_6,
    ref_15.c_2_c1702_3 AS c_2_c1724_7
FROM
    t0 AS ref_14
RIGHT JOIN cte_1 AS ref_15
    ON ref_14.c1 = ref_15.c_2_c1702_3
RIGHT JOIN t1 AS ref_16
    ON ref_14.pkey = ref_16.vkey;

DROP TABLE t0;

DROP TABLE t1;

DROP TABLE t3;