SELECT reverse((1, 'Hello', [2, 3]));

DROP TABLE IF EXISTS t_tuple;

CREATE TABLE t_tuple
(
    tuple Tuple(a Int32, b String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t_tuple;

SELECT reverse(tuple)
FROM t_tuple;

SELECT
    reverse(tuple).a,
    reverse(tuple).b
FROM t_tuple;

DROP TABLE t_tuple;