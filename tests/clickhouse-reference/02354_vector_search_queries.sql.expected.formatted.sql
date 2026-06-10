-- Tags: no-fasttest, no-ordinary-database
-- Tests various simple approximate nearest neighborhood (ANN) queries that utilize vector search indexes.
-- Test runs with analyzer enabled
SET enable_analyzer = '1';

SELECT '10 rows, index_granularity = 8192, GRANULARITY = 1 million --> 1 granule, 1 indexed block';

CREATE TABLE tab
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '8192';

INSERT INTO tab;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

DROP TABLE tab;

SELECT '12 rows, index_granularity = 3, GRANULARITY = 2 --> 4 granules, 2 indexed block';

CREATE TABLE tab
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

INSERT INTO tab;

SELECT '-- Non-default metric, hnsw_max_connections_per_layer, hnsw_candidate_list_size_for_construction';

CREATE TABLE tab
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 2, 'f32', 42, 99) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

INSERT INTO tab;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3
SETTINGS max_limit_for_vector_search_queries = '2'; -- LIMIT 3 > 2 --> don't use the ann index

DROP TABLE IF EXISTS tab_l2_f64;

DROP TABLE IF EXISTS tab_l2_f32;

DROP TABLE IF EXISTS tab_l2_f16;

DROP TABLE IF EXISTS tab_l2_bf16;

DROP TABLE IF EXISTS tab_l2_i8;

DROP TABLE IF EXISTS tab_cos_f64;

DROP TABLE IF EXISTS tab_cos_f32;

DROP TABLE IF EXISTS tab_cos_f16;

DROP TABLE IF EXISTS tab_cos_bf16;

DROP TABLE IF EXISTS tab_cos_i8;

CREATE TABLE tab_l2_f64
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2, 'f64', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_l2_f32
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2, 'f32', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_l2_f16
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2, 'f16', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_l2_bf16
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2, 'bf16', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_l2_i8
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2, 'i8', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_cos_f64
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 2, 'f64', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_cos_f32
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 2, 'f32', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_cos_f16
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 2, 'f16', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_cos_bf16
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 2, 'bf16', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab_cos_i8
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 2, 'i8', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

INSERT INTO tab_l2_f64;

INSERT INTO tab_l2_f32;

INSERT INTO tab_l2_f16;

INSERT INTO tab_l2_bf16;

INSERT INTO tab_l2_i8;

INSERT INTO tab_cos_f64;

INSERT INTO tab_cos_f32;

INSERT INTO tab_cos_f16;

INSERT INTO tab_cos_bf16;

INSERT INTO tab_cos_i8;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_f64
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_f64
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_f32
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_f32
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_f16
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_f16
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_bf16
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_bf16
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_i8
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab_l2_i8
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_f64
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_f64
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_f32
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_f32
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_f16
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_f16
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_bf16
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_bf16
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_i8
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec)
FROM tab_cos_i8
ORDER BY cosineDistance(vec, reference_vec) ASC
LIMIT 3;

DROP TABLE tab_l2_f64;

DROP TABLE tab_l2_f32;

DROP TABLE tab_l2_f16;

DROP TABLE tab_l2_bf16;

DROP TABLE tab_l2_i8;

DROP TABLE tab_cos_f64;

DROP TABLE tab_cos_f32;

DROP TABLE tab_cos_f16;

DROP TABLE tab_cos_bf16;

DROP TABLE tab_cos_i8;

CREATE TABLE tab
(
    id Int32,
    vec Array(Float64),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

CREATE TABLE tab
(
    id Int32,
    vec Array(BFloat16),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';