-- Tags: no-parallel
-- Tag no-parallel: Messes with internal cache
SET enable_analyzer = '1';

SET query_cache_system_table_handling = 'save';

SYSTEM CLEAR QUERY CACHE;

-- Run a silly query with a non-trivial plan and put the result into the query cache QC
SELECT 1 + number
FROM `system`.numbers
LIMIT 1
SETTINGS use_query_cache = true;

SELECT count(*)
FROM `system`.query_cache;

-- EXPLAIN PLAN should show the same regardless if the result is calculated or read from the QC
EXPLAIN
SELECT 1 + number
FROM `system`.numbers
LIMIT 1;

EXPLAIN
SELECT 1 + number
FROM `system`.numbers
LIMIT 1
SETTINGS use_query_cache = true; -- (*)

-- EXPLAIN PIPELINE should show the same regardless if the result is calculated or read from the QC
EXPLAIN PIPELINE
SELECT 1 + number
FROM `system`.numbers
LIMIT 1;

EXPLAIN PIPELINE
SELECT 1 + number
FROM `system`.numbers
LIMIT 1
SETTINGS use_query_cache = true; -- (*)