DROP TABLE IF EXISTS t_tuple_sparse;

CREATE TABLE t_tuple_sparse
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS ratio_of_defaults_for_sparse_serialization = 0.;

INSERT INTO t_tuple_sparse;

SELECT (a, b)
FROM t_tuple_sparse;

SELECT (a, 0)
FROM t_tuple_sparse;

SELECT (a, 1)
FROM t_tuple_sparse;

SELECT (a, NULL)
FROM t_tuple_sparse;