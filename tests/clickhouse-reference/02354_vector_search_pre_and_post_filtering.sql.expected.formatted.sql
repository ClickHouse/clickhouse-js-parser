-- Tags: no-fasttest, no-ordinary-database
-- Tests pre vs. post-filtering for vector search.
SET enable_analyzer = '1';

SET parallel_replicas_local_plan = '1'; -- this setting is randomized, set it explicitly to have local plan for parallel replicas

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id Int32,
    date Date,
    attr1 Int32,
    attr2 Int32,
    vec Array(Float32),
    INDEX idx_attr1 attr1 TYPE minmax() GRANULARITY 1,
    INDEX idx_vec vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 10000
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY date
SETTINGS index_granularity = '3';

INSERT INTO tab;

SELECT '-- No additional WHERE clauses present, expect index usage';

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                ORDER BY L2Distance(vec, [1., 1.]) ASC
                LIMIT 2
                SETTINGS vector_search_filter_strategy = 'prefilter'
            ))
    )
WHERE `explain` LIKE '%vector_similarity%'
    OR `explain` LIKE '%Granules: 3/4%';

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE attr2 >= 1006
                ORDER BY L2Distance(vec, [1., 1.]) ASC
                LIMIT 2
                SETTINGS vector_search_filter_strategy = 'prefilter'
            ))
    )
WHERE `explain` LIKE '%vector_similarity%';

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE attr1 <= 105
                ORDER BY L2Distance(vec, [1., 1.]) ASC
                LIMIT 2
                SETTINGS vector_search_filter_strategy = 'prefilter'
            ))
    )
WHERE `explain` LIKE '%vector_similarity%';

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE id <= 6
                ORDER BY L2Distance(vec, [1., 1.]) ASC
                LIMIT 2
                SETTINGS vector_search_filter_strategy = 'prefilter'
            ))
    )
WHERE `explain` LIKE '%vector_similarity%';

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                ORDER BY L2Distance(vec, [1., 1.]) ASC
                LIMIT 2
                SETTINGS vector_search_filter_strategy = 'postfilter'
            ))
    )
WHERE `explain` LIKE '%vector_similarity%'
    OR `explain` LIKE '%Granules: 3/4%';

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE date <= '2025-01-02'
                ORDER BY L2Distance(vec, [1., 1.]) ASC
                LIMIT 2
                SETTINGS vector_search_filter_strategy = 'postfilter'
            ))
    )
WHERE `explain` LIKE '%vector_similarity%';

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE date = '2025-01-03'
                    AND attr1 = 110
                ORDER BY L2Distance(vec, [1., 1.]) ASC
                LIMIT 2
                SETTINGS vector_search_filter_strategy = 'postfilter'
            ))
    )
WHERE `explain` LIKE '%vector_similarity%';

SELECT id
FROM tab
WHERE date = '2025-01-03'
    AND id <= 9
ORDER BY L2Distance(vec, [1., 1.]) ASC
LIMIT 2
SETTINGS
    log_comment = '02354_vector_search_post_filter_strategy_query1',
    vector_search_with_rescoring = '1';

SYSTEM FLUSH LOGS query_log;

SELECT DISTINCT ProfileEvents['USearchSearchCount']
FROM `system`.query_log
WHERE log_comment = '02354_vector_search_post_filter_strategy_query1'
    AND current_database = currentDatabase()
    AND type = 'QueryFinish';

SELECT id
FROM tab
WHERE date = '2025-01-03'
    AND attr2 >= 1008
ORDER BY L2Distance(vec, [1., 1.]) ASC
LIMIT 3;

SELECT id
FROM tab
WHERE date = '2025-01-03'
    AND attr2 >= 1008
ORDER BY L2Distance(vec, [1., 1.]) ASC
LIMIT 3
SETTINGS vector_search_index_fetch_multiplier = 2.;

SELECT id
FROM tab
WHERE date = '2025-01-03'
    AND attr2 >= 1008
ORDER BY L2Distance(vec, [1., 1.]) ASC
LIMIT 3
SETTINGS vector_search_index_fetch_multiplier = -1.; -- { serverError INVALID_SETTING_VALUE }

SELECT id
FROM tab
WHERE date = '2025-01-03'
    AND attr2 >= 1008
ORDER BY L2Distance(vec, [1., 1.]) ASC
LIMIT 3
SETTINGS vector_search_index_fetch_multiplier = 0.; -- { serverError INVALID_SETTING_VALUE }

SELECT id
FROM tab
WHERE date = '2025-01-03'
    AND attr2 >= 1008
ORDER BY L2Distance(vec, [1., 1.]) ASC
LIMIT 3
SETTINGS vector_search_index_fetch_multiplier = 1001.; -- { serverError INVALID_SETTING_VALUE }

DROP TABLE tab;