-- { echo ON }
DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int
)
ENGINE = SummingMergeTree()
PRIMARY KEY c0
ORDER BY (c0 DESC)
SETTINGS allow_experimental_reverse_key = '1';

INSERT INTO t0 (c0);

SELECT sum(c0)
FROM t0 FINAL;

DROP TABLE t0;

CREATE TABLE t0
(
    c0 Int,
    c1 Int
)
ENGINE = SummingMergeTree()
PRIMARY KEY c0
ORDER BY (c0 DESC, c1)
SETTINGS allow_experimental_reverse_key = '1';

CREATE TABLE t0
(
    c0 Int,
    c1 Int
)
ENGINE = SummingMergeTree()
ORDER BY (c0 DESC, c1)
SETTINGS allow_experimental_reverse_key = '1';