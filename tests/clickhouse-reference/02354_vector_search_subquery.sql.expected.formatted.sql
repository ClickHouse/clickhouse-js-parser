-- Tags: no-fasttest, no-ordinary-database
SET enable_analyzer = '1'; -- analyzer vs. non-analyzer produce slightly different EXPLAIN

-- Reference vector for vector search is computed by a subquery (issue #69085)
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 2, 'f16', 0, 0) GRANULARITY 2
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '3';

INSERT INTO tab;

-- this works
EXPLAIN indexes = '1'
WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec) AS distance
FROM tab
ORDER BY distance ASC
LIMIT 1;

-- this also work
EXPLAIN indexes = '1'
WITH (
        SELECT vec
        FROM tab
        LIMIT 1
    ) AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec) AS distance
FROM tab
ORDER BY distance ASC
LIMIT 1;

-- and this works as well
EXPLAIN indexes = '1'
WITH (
        SELECT [0., 2.]
    ) AS reference_vec

SELECT
    id,
    vec,
    cosineDistance(vec, reference_vec) AS distance
FROM tab
ORDER BY distance ASC
LIMIT 1;

DROP TABLE tab;