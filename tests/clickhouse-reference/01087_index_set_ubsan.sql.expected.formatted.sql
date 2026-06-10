DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    i Int,
    a Int,
    s String,
    INDEX ind_s s TYPE set(1) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO t;

SELECT
    a,
    i
FROM t
ORDER BY
    a ASC,
    i ASC;

DROP TABLE t;