DROP TABLE IF EXISTS t0, t1, t4, t5;

SET join_use_nulls = '1';

CREATE TABLE t0
(
    c2 String,
    PRIMARY KEY(c2)
)
ENGINE = MergeTree();

CREATE TABLE t1
(
    vkey UInt32,
    c8 String,
    PRIMARY KEY(vkey)
)
ENGINE = MergeTree();

CREATE VIEW t4
AS
SELECT ref_1.vkey AS c_2_c48_2
FROM
    t0 AS ref_0
LEFT JOIN t1 AS ref_1
    ON ref_0.c2 = ref_1.c8;

CREATE TABLE t5
(
    pkey UInt32,
    c52 UInt32,
    c56 String,
    PRIMARY KEY(pkey)
)
ENGINE = MergeTree();

INSERT INTO t0;

INSERT INTO t0;

INSERT INTO t1;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

INSERT INTO t5;

SELECT count(*)
FROM
    t5 AS ref_2
LEFT JOIN (
        SELECT ref_3.c_2_c48_2 AS c_6_c185_6
        FROM t4 AS ref_3
    ) AS subq_1
    ON ref_2.c52 = subq_1.c_6_c185_6
WHERE intExp2(ref_2.pkey) <= multiIf(subq_1.c_6_c185_6 = 1
    AND NOT subq_1.c_6_c185_6 = 1, 0, hiveHash(ref_2.c56));

SELECT count(*)
FROM
    t5 AS ref_2
LEFT JOIN (
        SELECT ref_3.c_2_c48_2 AS c_6_c185_6
        FROM t4 AS ref_3
    ) AS subq_1
    ON ref_2.c52 = subq_1.c_6_c185_6
WHERE intExp2(ref_2.pkey) <= hiveHash(ref_2.c56);

DROP TABLE t0, t1, t4, t5;