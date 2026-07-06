-- https://github.com/ClickHouse/ClickHouse/issues/50271
DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

SET enable_analyzer = '1';

CREATE TABLE t1
(
    c3 String,
    PRIMARY KEY(c3)
)
ENGINE = MergeTree();

CREATE TABLE t2
(
    c11 String,
    PRIMARY KEY(c11)
)
ENGINE = MergeTree();

INSERT INTO t1;

INSERT INTO t2;

SELECT ref_0.c11 AS c_2_c30_0
FROM
    t2 AS ref_0
CROSS JOIN (
        SELECT ref_1.c3 AS c_6_c28_15
        FROM t1 AS ref_1
    ) AS subq_0
WHERE subq_0.c_6_c28_15 = (
        SELECT c11
        FROM t2
        ORDER BY c11 ASC
        LIMIT 1
    );