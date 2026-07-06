SET enable_analyzer = '1';

CREATE TABLE t0
(
    c0 Nullable(Int)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY c0
SETTINGS allow_nullable_key = '1';

SET optimize_functions_to_subcolumns = '0';

INSERT INTO t0 (c0);

SELECT count()
FROM t0
WHERE (t0.c0 IS NULL) = true;