CREATE TABLE test_tuple
(
    p DateTime,
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY (toDate(p), i)
SETTINGS index_granularity = '1';

INSERT INTO test_tuple;

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SELECT count()
FROM test_tuple
PREWHERE sipHash64(sipHash64(p, toString(toDate(p))), toString(toDate(p))) % -0.
WHERE i > NULL
SETTINGS
    optimize_trivial_count_query = '0',
    optimize_use_implicit_projections = '1'; -- { serverError ILLEGAL_TYPE_OF_COLUMN_FOR_FILTER }