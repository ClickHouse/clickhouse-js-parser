-- Tags: no-fasttest, no-ordinary-database
SET parallel_replicas_local_plan = '1'; -- this setting is randomized, set it explicitly to have local plan for parallel replicas

-- Test for issue #77978
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id Int32,
    vec1 Array(Float32),
    vec2 Array(Float32),
    INDEX idx vec1 TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab;

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                WITH [0., 2.] AS reference_vec

                SELECT id
                FROM tab
                ORDER BY L2Distance(vec1, reference_vec) ASC
                LIMIT 3
            ))
    )
WHERE `explain` ILIKE '%Skip%'
    OR `explain` ILIKE '%Name: idx%'
    OR `explain` ILIKE '%vector_similarity%';

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                WITH [0., 2.] AS reference_vec

                SELECT id
                FROM tab
                ORDER BY L2Distance(vec2, reference_vec) ASC
                LIMIT 3
            ))
    )
WHERE `explain` ILIKE '%Skip%'
    OR `explain` ILIKE '%Name: idx%'
    OR `explain` ILIKE '%vector_similarity%';

DROP TABLE tab;