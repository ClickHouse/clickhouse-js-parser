-- Tags: no-fasttest, no-ordinary-database
-- Tests that vector similarity indexes reject INSERTs of Arrays with sizes != than the size specified in the index
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id Int32,
    vec Array(Float32),
    INDEX idx vec TYPE vector_similarity('hnsw', 'L2Distance', 2) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id;

-- Mixed correct/wrong
INSERT INTO tab; -- { serverError INCORRECT_DATA }

-- Both wrong but of the same length
INSERT INTO tab; -- { serverError INCORRECT_DATA }

DROP TABLE tab;