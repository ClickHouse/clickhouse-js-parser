DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS t_buf;

CREATE TABLE t
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY (x, intHash64(x))
SAMPLE BY intHash64(x);

INSERT INTO t SELECT number
FROM numbers(10000);

CREATE TABLE t_buf AS t
ENGINE = Buffer(currentDatabase(), 't', 16, 20, 100, 100000, 10000000, 50000000, 250000000);

INSERT INTO t_buf;

SELECT count()
FROM t_buf SAMPLE 1/2
FORMAT Null;