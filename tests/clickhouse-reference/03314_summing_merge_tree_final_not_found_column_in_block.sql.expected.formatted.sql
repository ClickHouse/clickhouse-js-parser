DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int,
    c1 Nullable(Int) MATERIALIZED 1
)
ENGINE = SummingMergeTree()
PRIMARY KEY abs(c1)
SETTINGS allow_nullable_key = '1';

INSERT INTO t0 (c0);

SELECT c0
FROM t0 FINAL;