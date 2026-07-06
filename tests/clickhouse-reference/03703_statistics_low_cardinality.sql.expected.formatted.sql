-- Tags: no-fasttest
SET use_statistics = '1';

CREATE TABLE t
(
    a Nullable(Int),
    b LowCardinality(Nullable(String))
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS auto_statistics_types = 'minmax,uniq,tdigest,countmin';

INSERT INTO t;

SELECT *
FROM t
WHERE a > 1
    AND b = '1';