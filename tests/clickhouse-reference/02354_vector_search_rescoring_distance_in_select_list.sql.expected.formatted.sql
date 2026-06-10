-- Tags: no-fasttest, no-ordinary-database, no-parallel-replicas
--- no-parallel-replicas: Because the test records and verifies
--- _distance values returned from the rescoring optimization.
-- Issue #85514
--
-- Tests that the rescoring optimization works when distance function is
-- present explicitly in the SELECT columns list, apart from ORDER BY.
-- The return type of the cosineDistance/L2Distance function will vary
-- based on the data type of the 2 input arguments.
SET enable_analyzer = '1';

SET vector_search_with_rescoring = '0';

DROP TABLE IF EXISTS tab_f32;

DROP TABLE IF EXISTS tab_bf16;

CREATE TABLE tab_f32
(
    id Int32,
    vec Array(Float32),
    INDEX vector_index vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '1';

CREATE TABLE tab_bf16
(
    id Int32,
    vec Array(BFloat16),
    INDEX vector_index vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '1';

INSERT INTO tab_f32;

INSERT INTO tab_bf16;

SELECT '-- Search vector: Array(Float64)';

WITH CAST([0., 2.] AS Array(Float64)) AS reference_vec

SELECT
    id,
    L2Distance(vec, reference_vec)
FROM tab_f32
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 4;

WITH CAST([0., 2.] AS Array(BFloat16)) AS reference_vec

SELECT
    id,
    L2Distance(vec, reference_vec)
FROM tab_f32
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 4;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    L2Distance(vec, reference_vec)
FROM tab_bf16
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 4;

WITH CAST([0., 2.] AS Array(BFloat16)) AS reference_vec

SELECT
    id,
    L2Distance(vec, reference_vec)
FROM tab_bf16
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 4;

WITH CAST([0., 2.] AS Array(Float32)) AS reference_vec

SELECT
    id,
    L2Distance(vec, reference_vec)
FROM tab_bf16
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 4;

DROP TABLE tab_f32;

DROP TABLE tab_bf16;