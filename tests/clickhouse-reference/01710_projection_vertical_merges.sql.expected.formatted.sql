-- Tags: long, no-parallel, no-msan, no-tsan, no-asan
-- set no-parallel and no sanitizers tag is to prevent timeout of this test
DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    c1 Int64,
    c2 String,
    c3 DateTime,
    c4 Int8,
    c5 String,
    c6 String,
    c7 String,
    c8 String,
    c9 String,
    c10 String,
    c11 String,
    c12 String,
    c13 Int8,
    c14 Int64,
    c15 String,
    c16 String,
    c17 String,
    c18 Int64,
    c19 Int64,
    c20 Int64
)
ENGINE = MergeTree()
ORDER BY c18
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t (c1, c18) SELECT
    number,
    -number
FROM numbers(2000000);

ALTER TABLE t ADD PROJECTION p_norm (SELECT * ORDER BY c1);

OPTIMIZE TABLE t FINAL;

ALTER TABLE t MATERIALIZE PROJECTION p_norm SETTINGS mutations_sync = '1';

SET optimize_use_projections = '1', max_rows_to_read = '3';

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SELECT c18
FROM t
WHERE c1 < 0;

DROP TABLE t;