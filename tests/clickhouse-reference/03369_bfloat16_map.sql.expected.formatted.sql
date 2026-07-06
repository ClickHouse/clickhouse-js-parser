DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Map(Int, Int),
    c1 Nullable(BFloat16)
)
ENGINE = MergeTree()
ORDER BY (c1, c0)
SETTINGS allow_nullable_key = '1';

INSERT INTO t0 (c0, c1);

SELECT c1
FROM t0
ORDER BY c1 ASC;

DROP TABLE t0;