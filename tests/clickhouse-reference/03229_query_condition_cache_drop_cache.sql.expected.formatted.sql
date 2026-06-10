-- Tags: no-parallel, no-release
-- Tag no-parallel: Messes with internal cache
-- Tag release: Checks fields in system.query_condition_cache which are not available in release builds
-- Tests that SYSTEM CLEAR QUERY CONDITION CACHE works
SET allow_experimental_analyzer = '1';

-- (it's silly to use what will be tested below but we have to assume other tests cluttered the query cache)
SYSTEM CLEAR QUERY CONDITION CACHE;

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    a Int64,
    b Int64
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO tab SELECT
    number,
    number
FROM numbers(1000000); -- 1 mio rows sounds like a lot but the QCC doesn't cache anything if there is less data

SELECT count(*)
FROM tab
WHERE b = 10000
SETTINGS use_query_condition_cache = true
FORMAT Null;

SELECT count(*)
FROM `system`.query_condition_cache;

DROP TABLE tab;