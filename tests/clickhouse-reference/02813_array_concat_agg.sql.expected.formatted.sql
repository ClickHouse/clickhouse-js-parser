DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    n UInt32,
    a Array(Int32)
)
ENGINE = Memory();

INSERT INTO t;

SELECT array_concat_agg(a)
FROM t;

SELECT
    n,
    array_concat_agg(a)
FROM t
GROUP BY n
ORDER BY n ASC;

DROP TABLE t;