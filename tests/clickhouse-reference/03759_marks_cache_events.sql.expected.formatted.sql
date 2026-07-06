-- Tags: no-parallel-replicas, no-parallel
-- Test depends on mark cache, don't run with others in parallel
DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    key Int
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS prewarm_mark_cache = '0';

SET load_marks_asynchronously = '0';

INSERT INTO data;

--
-- SELECTs
--
SELECT *
FROM data
FORMAT Null
SETTINGS load_marks_asynchronously = '0';

-- drop marks cache
DETACH TABLE data;

ATTACH TABLE data;

SELECT *
FROM data
FORMAT Null
SETTINGS load_marks_asynchronously = '1';

SYSTEM FLUSH LOGS query_log;

SELECT
    query_kind,
    `Settings`['load_marks_asynchronously'] AS load_marks_asynchronously,
    ProfileEvents['MarkCacheHits'] AS hits,
    ProfileEvents['MarkCacheMisses'] AS misses
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query_kind IN ('Select', 'Insert')
    AND type != 'QueryStart'
ORDER BY event_time_microseconds ASC
FORMAT CSVWithNames;

--
-- metrics for merges
--
-- only hits
OPTIMIZE TABLE data FINAL;

SYSTEM FLUSH LOGS part_log;

SELECT
    part_name,
    ProfileEvents['MarkCacheHits'] AS hits,
    ProfileEvents['MarkCacheMisses'] AS misses
FROM `system`.part_log
WHERE database = currentDatabase()
    AND event_type = 'MergeParts'
ORDER BY event_time_microseconds ASC
FORMAT CSVWithNames;