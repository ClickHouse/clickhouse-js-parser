DROP TABLE IF EXISTS t_key_condition_float;

CREATE TABLE t_key_condition_float
(
    a Float32
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO t_key_condition_float;

SELECT count()
FROM t_key_condition_float
WHERE a > 0;

SELECT count()
FROM t_key_condition_float
WHERE a > 0.;

SELECT count()
FROM t_key_condition_float
WHERE a > CAST('0' AS Float32);

SELECT count()
FROM t_key_condition_float
WHERE a > CAST('0' AS Float64);

DROP TABLE t_key_condition_float;

CREATE TABLE t_key_condition_float
(
    a Float64
)
ENGINE = MergeTree()
ORDER BY a;

CREATE TABLE t_key_condition_float
(
    a UInt64
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO t_key_condition_float;

SELECT count()
FROM t_key_condition_float
WHERE a > 1.5;