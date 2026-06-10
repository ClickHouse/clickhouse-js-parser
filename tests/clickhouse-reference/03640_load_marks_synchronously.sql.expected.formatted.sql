-- Tags: no-parallel-replicas, no-parallel
-- Test depends on mark cache, don't run with others in parallel
-- Note: we need to have index_granularity==number or rows, to avoid processing
-- parts in parallel, since in this case marks can be requested from multiple
-- threads, which will lead to the query will have both MarksTasksFromCache and
-- BackgroundLoadingMarksTasks
CREATE TABLE data
(
    key int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS prewarm_mark_cache = '0', index_granularity = '1000';

INSERT INTO data SELECT *
FROM numbers(1000);

SELECT *
FROM data
SETTINGS load_marks_asynchronously = '1'
FORMAT Null; /* 1 */

SYSTEM FLUSH LOGS query_log;

SELECT
    query,
    ProfileEvents['BackgroundLoadingMarksTasks'] > 0 AS async,
    ProfileEvents['MarksTasksFromCache'] > 0 AS sync
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query_kind = 'Select'
    AND type != 'QueryStart'
ORDER BY event_time_microseconds ASC
FORMAT Vertical;