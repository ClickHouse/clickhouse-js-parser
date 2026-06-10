DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    v Variant(Map(String, Int32), Tuple(String, Int32))
)
ENGINE = Memory();

INSERT INTO t;

SELECT *
FROM t;

DROP TABLE t;