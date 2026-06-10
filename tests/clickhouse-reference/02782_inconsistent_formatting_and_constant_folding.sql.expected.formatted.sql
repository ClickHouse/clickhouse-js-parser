SELECT
    0,
    toTypeName(0),
    -1,
    toTypeName(-1),
    -0.,
    toTypeName(-0.);

DROP TABLE IF EXISTS t4;

DROP TABLE IF EXISTS t7;

CREATE TABLE t4
(
    c26 String
)
ENGINE = Log();

CREATE VIEW t7
AS
SELECT max(ref_3.c26) AS c_2_c46_1
FROM t4 AS ref_3;

SELECT c_7_c4585_14 AS c_4_c4593_5
FROM (
        SELECT
            avg(0) AS c_7_c4572_1,
            max(0) AS c_7_c4585_14
        FROM t7 AS ref_0
        GROUP BY ref_0.c_2_c46_1
    ) AS subq_0
WHERE c_4_c4593_5 <= multiIf(true, 1, exp10(c_4_c4593_5) <= 1, 1, 1);

SELECT x AS c
FROM (
        SELECT
            1 AS k,
            max(0) AS a,
            max(0) AS x
        FROM t7
        GROUP BY k
    )
WHERE NOT ignore(c);

SELECT x
FROM (
        SELECT
            avg(0) AS c_7_c4572_1,
            max(0) AS x
        FROM t7 AS ref_0
        GROUP BY ref_0.c_2_c46_1
    )
WHERE x <= multiIf(true, 1, exp10(x) <= 1, 1, 1);

DROP TABLE t7;

DROP TABLE t4;