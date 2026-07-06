SET enable_analyzer = '1';

CREATE TABLE t0
(
    c0 Nullable(Int)
)
ENGINE = SummingMergeTree()
ORDER BY tuple()
PARTITION BY c0
SETTINGS allow_nullable_key = '1';

INSERT INTO t0 (c0);

SELECT *
FROM t0 FINAL;

SELECT count()
FROM t0 FINAL
WHERE (t0.c0 IS NULL) = true;