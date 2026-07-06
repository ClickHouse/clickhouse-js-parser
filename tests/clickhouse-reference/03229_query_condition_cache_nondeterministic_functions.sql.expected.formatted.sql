-- Tags: no-parallel
-- Tag no-parallel: Messes with internal cache
-- Tests that the query condition cache rejects conditions with non-deterministic functions
SET allow_experimental_analyzer = '1';

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
FROM numbers(1000000); -- 1 mio rows sounds like a lot but the QCC doesn't cache anything for less data

SELECT '--- with move to PREWHERE';

SET optimize_move_to_prewhere = true;

SYSTEM CLEAR QUERY CONDITION CACHE;

SELECT count(*)
FROM tab
WHERE b = rand64()
SETTINGS use_query_condition_cache = true
FORMAT Null;

SELECT count(*)
FROM `system`.query_condition_cache;

SET optimize_move_to_prewhere = false;

DROP TABLE tab;