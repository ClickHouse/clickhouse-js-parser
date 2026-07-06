SET enable_analyzer = '1';

CREATE TABLE t0
(
    k1 Nullable(Int)
)
ENGINE = Memory();

CREATE TABLE t2
(
    k1 Int
)
ENGINE = Join(`ALL`, `FULL`, k1);

INSERT INTO t0;

INSERT INTO t2;

SELECT t1.k1
FROM
    t0
FULL JOIN t2 AS t1
    USING (k1)
FULL JOIN t2 AS t2
    USING (k1);