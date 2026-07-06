-- Tags: no-parallel
-- Tag no-parallel: Messes with internal cache
SYSTEM CLEAR QUERY CACHE;

DROP TABLE IF EXISTS t;

-- Create test table with lot's of rows
CREATE TABLE t
(
    c String
)
ENGINE = MergeTree()
ORDER BY c;

INSERT INTO t SELECT multiIf(n = 0, 'abc', n = 1, 'def', n = 2, 'abc', n = 3, 'jkl', '<unused>')
FROM (
        SELECT number % 4 AS n
        FROM numbers(1200)
    );

OPTIMIZE TABLE t FINAL;

-- Run query which, store *compressed* result in query cache
SELECT '-- insert with enabled compression';

SELECT *
FROM t
ORDER BY c ASC
SETTINGS
    use_query_cache = true,
    query_cache_compress_entries = true;

SELECT *
FROM t
ORDER BY c ASC
SETTINGS use_query_cache = true;

SELECT *
FROM t
ORDER BY c ASC
SETTINGS
    use_query_cache = true,
    query_cache_compress_entries = false;

DROP TABLE t;