DROP TABLE IF EXISTS t_sample_factor;

CREATE TABLE t_sample_factor
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY (a, b)
SAMPLE BY b;

INSERT INTO t_sample_factor (a, b);

SELECT uniq(b) * any(_sample_factor)
FROM t_sample_factor SAMPLE 200000;

SELECT uniq(b) * any(_sample_factor)
FROM t_sample_factor SAMPLE 200000
WHERE a < -1;

SELECT uniq(b) * any(_sample_factor)
FROM t_sample_factor SAMPLE 200000
PREWHERE a < -1;

DROP TABLE t_sample_factor;