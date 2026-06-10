DROP TABLE IF EXISTS t_parse_tuples;

CREATE TABLE t_parse_tuples
(
    id UInt32,
    arr Array(Array(Tuple(c1 Int32, c2 UInt8)))
)
ENGINE = Memory();

INSERT INTO t_parse_tuples;

SELECT *
FROM t_parse_tuples
ORDER BY id ASC;