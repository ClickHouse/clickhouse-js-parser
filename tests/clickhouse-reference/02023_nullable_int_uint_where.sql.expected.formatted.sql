DROP TABLE IF EXISTS t1;

SET allow_suspicious_low_cardinality_types = '1';

CREATE TABLE t1
(
    id LowCardinality(Nullable(Int64))
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS allow_nullable_key = '1', index_granularity = '1';

INSERT INTO t1;

SELECT *
FROM t1
WHERE id = 21585718595728998;

DROP TABLE t1;