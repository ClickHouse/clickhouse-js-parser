-- Tags: no-parallel, no-release
-- Tag no-parallel: Messes with internal cache
-- Tag no-release: Checks fields in system.query_condition_cache which are not available in release builds
-- add_minmax_index_for_numeric_columns=0: Would use indices instead of the projections that we want to test
-- { echo ON }
SET enable_analyzer = '1';

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SET optimize_use_projection_filtering = '1';

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    i int,
    j int,
    PROJECTION p (SELECT * ORDER BY j)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1', add_minmax_index_for_numeric_columns = '0', max_bytes_to_merge_at_max_space_in_pool = '1'; -- disable merge

-- The following data is constructed in a way to verifies that query condition
-- cache no longer has key collisions for projection parts
INSERT INTO t SELECT
    20,
    number
FROM numbers(10);

INSERT INTO t SELECT
    1,
    number + 1
FROM numbers(10);

SYSTEM CLEAR QUERY CONDITION CACHE;

SELECT j
FROM t
WHERE j > 3
    AND i = 20
ORDER BY j ASC
SETTINGS
    max_threads = '1',
    use_query_condition_cache = '1',
    query_condition_cache_store_conditions_as_plaintext = '1';

SELECT part_name
FROM `system`.query_condition_cache
ORDER BY part_name ASC;

DROP TABLE t;