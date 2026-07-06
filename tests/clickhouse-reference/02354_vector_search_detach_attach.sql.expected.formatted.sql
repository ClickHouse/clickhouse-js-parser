-- Tags: no-fasttest, no-ordinary-database
-- Tests that vector similarity indexes can be detached/attached.
DROP TABLE IF EXISTS tab;

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

DETACH TABLE tab SYNC;

ATTACH TABLE tab;

WITH [0., 2.] AS reference_vec

SELECT
    id,
    vec,
    L2Distance(vec, reference_vec)
FROM tab
ORDER BY L2Distance(vec, reference_vec) ASC
LIMIT 3;

DROP TABLE tab;