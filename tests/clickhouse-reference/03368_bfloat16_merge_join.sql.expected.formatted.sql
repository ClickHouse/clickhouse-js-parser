DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Float64,
    c1 BFloat16
)
ENGINE = MergeTree()
PRIMARY KEY c0
PARTITION BY murmurHash3_64(c0);

SET join_algorithm = 'full_sorting_merge';

INSERT INTO t0 (c0, c1);

SELECT count()
FROM
    t0 AS t0d0
INNER JOIN t0 AS t1d0
    ON t1d0.c0 = t0d0.c0
INNER JOIN t0 AS t2d0
    ON t1d0.c1 = t2d0.c1
WHERE t1d0.c0 != t2d0.c0;

SELECT sum(t1d0.c0 != t2d0.c0)
FROM
    t0 AS t0d0
INNER JOIN t0 AS t1d0
    ON t1d0.c0 = t0d0.c0
INNER JOIN t0 AS t2d0
    ON t1d0.c1 = t2d0.c1;

DROP TABLE t0;