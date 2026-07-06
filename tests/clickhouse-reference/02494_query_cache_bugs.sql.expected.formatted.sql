-- Tags: no-parallel
-- Tag no-parallel: Messes with internal cache
-- Test for Bug 56258
SYSTEM CLEAR QUERY CACHE;

SELECT '-- Bug 56258: Check literals (ASTLiteral)';

SELECT 10
FORMAT Vertical
SETTINGS use_query_cache = '1';

SELECT 10 AS x
FORMAT Vertical
SETTINGS use_query_cache = '1';

SELECT count(*)
FROM `system`.query_cache;

SELECT toUInt64(42)
FORMAT Vertical
SETTINGS use_query_cache = '1';

SELECT toUInt64(42) AS x
FORMAT Vertical
SETTINGS use_query_cache = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    c UInt64
)
ENGINE = Memory() AS
SELECT 1;

SELECT c
FROM tab
FORMAT Vertical
SETTINGS use_query_cache = '1';

SELECT c AS x
FROM tab
FORMAT Vertical
SETTINGS use_query_cache = '1';

DROP TABLE tab;

CREATE TABLE tab
(
    c UInt64
)
ENGINE = Memory();

SELECT sum(c)
FROM tab
SETTINGS
    read_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    read_overflow_mode_leaf = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    group_by_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    sort_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    result_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    timeout_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    set_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    join_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    transfer_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }

SELECT sum(c)
FROM tab
SETTINGS
    distinct_overflow_mode = 'break',
    use_query_cache = '1'; -- { serverError QUERY_CACHE_USED_WITH_NON_THROW_OVERFLOW_MODE }