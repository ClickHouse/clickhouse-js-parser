-- Tags: no-parallel
-- Tag no-parallel: Messes with internal cache
SYSTEM CLEAR QUERY CACHE;

DROP TABLE IF EXISTS t;

-- Create test table with "many" rows
CREATE TABLE t
(
    c String
)
ENGINE = MergeTree()
ORDER BY c;

SYSTEM STOP MERGES t; -- retain multiple parts to make the SELECT process multiple chunks

INSERT INTO t;

-- Run query which reads multiple chunks (small max_block_size), cache result in query cache, force squashing of partial results
SELECT '-- insert with enabled squashing';

SELECT *
FROM t
ORDER BY c ASC
SETTINGS
    max_block_size = '3',
    use_query_cache = true,
    query_cache_squash_partial_results = true;

SELECT *
FROM t
ORDER BY c ASC
SETTINGS
    max_block_size = '3',
    use_query_cache = true;

SELECT *
FROM t
ORDER BY c ASC
SETTINGS
    max_block_size = '3',
    use_query_cache = true,
    query_cache_squash_partial_results = false;

DROP TABLE t;