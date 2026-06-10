DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 String,
    c1 Tuple(Nullable(Int))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO t0 (c0) SELECT 'abc'
FROM numbers(142);

INSERT INTO t0 (c0);

ALTER TABLE t0 CLEAR COLUMN c0;

INSERT INTO t0 (c0) SELECT 'abc'
FROM numbers(196);

DROP TABLE t0;