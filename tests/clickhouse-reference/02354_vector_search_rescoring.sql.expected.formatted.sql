-- Tags: no-fasttest, no-ordinary-database, no-parallel-replicas
-- no-parallel-replicas: If parallel replicas are on, the optimization (no rescoring) may not work.
-- Test for setting 'vector_search_with_rescoring'
SET enable_analyzer = '1';

SET parallel_replicas_local_plan = '1'; -- this setting is randomized, set it explicitly to force local plan for parallel replicas

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id Int32,
    vec Array(Float32),
    attr1 Int32,
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '2';

INSERT INTO tab;

WITH [0., 2.] AS reference_vec

SELECT id
FROM tab
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3
SETTINGS vector_search_with_rescoring = '0';

SELECT '-- Expect column "_distance" in EXPLAIN. Column "vec" is not expected for ReadFromMergeTree.';

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1', (
                WITH [0., 2.] AS reference_vec

                SELECT id
                FROM tab
                ORDER BY L2Distance(vec, reference_vec) ASC
                LIMIT 3
                SETTINGS vector_search_with_rescoring = '0'
            ))
    )
WHERE (`explain` LIKE '%_distance%'
    OR `explain` LIKE '%vec%Array%')
    AND `explain` NOT LIKE '%L2Distance%';

WITH [0., 2.] AS reference_vec

SELECT id
FROM tab
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3
SETTINGS vector_search_with_rescoring = '1';

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1', (
                WITH [0., 2.] AS reference_vec

                SELECT id
                FROM tab
                ORDER BY L2Distance(vec, reference_vec) ASC
                LIMIT 3
                SETTINGS vector_search_with_rescoring = '1'
            ))
    )
WHERE `explain` LIKE '%_distance%';

-- SELECTing vec explicitly disables the optimization
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec
FROM tab
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3
SETTINGS vector_search_with_rescoring = '0';

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1', (
                WITH [0., 2.] AS reference_vec

                SELECT
                    id,
                    vec
                FROM tab
                ORDER BY L2Distance(vec, reference_vec) ASC
                LIMIT 3
                SETTINGS vector_search_with_rescoring = '0'
            ))
    )
WHERE `explain` LIKE '%_distance%';

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec
FROM tab
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3
SETTINGS vector_search_with_rescoring = '1';

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1', (
                WITH [0., 2.] AS reference_vec

                SELECT
                    id,
                    vec
                FROM tab
                ORDER BY L2Distance(vec, reference_vec) ASC
                LIMIT 3
                SETTINGS vector_search_with_rescoring = '1'
            ))
    )
WHERE `explain` LIKE '%_distance%';

-- Output will be 0,1,2
WITH [1., 0.] AS reference_vec

SELECT id
FROM tab
WHERE id <= 3
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3
SETTINGS vector_search_with_rescoring = '0';

-- Since filter will select partial ranges from part, brute-force search will select 4,5,6
WITH [1., 0.] AS reference_vec

SELECT
    id,
    attr1
FROM tab
WHERE id > 3
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3
SETTINGS vector_search_with_rescoring = '0';

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'header = 1', (
                WITH [0., 2.] AS reference_vec

                SELECT id
                FROM tab
                WHERE id >= 0
                ORDER BY L2Distance(vec, reference_vec) ASC
                LIMIT 5
                SETTINGS vector_search_with_rescoring = '0'
            ))
    )
WHERE (`explain` LIKE '%_distance%'
    OR `explain` LIKE '%vec%Array%')
    AND `explain` NOT LIKE '%L2Distance%';

-- Output will be 5,6,7,8,9
WITH [0., 2.] AS reference_vec

SELECT id
FROM tab
WHERE id >= 0
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 5
SETTINGS vector_search_with_rescoring = '0';

-- Output will be 0,1,2,3,4
WITH [1., 0.] AS reference_vec

SELECT
    id,
    attr1
FROM tab
WHERE attr1 >= 50
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 5
SETTINGS vector_search_with_rescoring = '0';