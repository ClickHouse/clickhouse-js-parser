-- Tags: no-fasttest, no-ordinary-database, no-parallel-replicas
-- Test for setting 'vector_search_with_rescoring' with filters.
SET enable_analyzer = '1';

SET parallel_replicas_local_plan = '1'; -- this setting is randomized, set it explicitly to force local plan for parallel replicas

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id Int32,
    attr1 Int32,
    attr2 Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '2';

INSERT INTO tab;

SELECT
    id,
    attr1,
    attr2,
    vec
FROM tab
ORDER BY L2Distance(vec, [0.2, 0.3]) ASC;

-- Expect IDs 16 & 19 for next 2 queries
SELECT id
FROM tab
WHERE attr1 > 110
ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
LIMIT 4
SETTINGS
    query_plan_optimize_prewhere = '0',
    optimize_move_to_prewhere = '0';

SELECT id
FROM tab
WHERE attr1 > 110
ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
LIMIT 4
SETTINGS
    query_plan_optimize_prewhere = '1',
    optimize_move_to_prewhere = '1';

-- Expect 16 & 19, and additionally 18 and 17 because they are in the same granules
SELECT id
FROM tab
WHERE attr1 > 110
ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
LIMIT 4
SETTINGS vector_search_with_rescoring = '1';

SELECT id
FROM tab
WHERE attr1 > 110
ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
LIMIT 4
SETTINGS
    vector_search_with_rescoring = '1',
    vector_search_index_fetch_multiplier = '3';

-- Expect no _distance column in result
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1', (
                SELECT id
                FROM tab
                PREWHERE attr1 > 110
                ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
                LIMIT 4
            ))
    )
WHERE `explain` LIKE '%_distance%';

SELECT id
FROM tab
PREWHERE attr1 > 110
ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
LIMIT 4;

SELECT
    id,
    attr1,
    attr2
FROM tab
ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
LIMIT 20;

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1', (
                SELECT
                    id,
                    attr1,
                    attr2,
                    L2Distance(vec, [0.2, 0.3])
                FROM tab
                ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
                LIMIT 20
            ))
    )
WHERE `explain` LIKE '%_distance%';

SELECT id
FROM tab
WHERE attr1 > 110
    AND attr2 > 50
ORDER BY L2Distance(vec, [0.2, 0.3]) ASC
LIMIT 4;

DROP TABLE tab;