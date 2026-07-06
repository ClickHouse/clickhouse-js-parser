-- Tags: no-fasttest, no-ordinary-database, no-parallel-replicas
-- no-parallel-replicas: The test really wants lower quality result to be returned from the index
--                       with rescoring=OFF. That is required to confirm binary quantization works
--                       as expected. In parallel replicas, rescoring is always ON.
-- Test for vector similarity index with binary quantization.
-- Also has good number of calls to reinterpret() to test conversion of native floats to Array(Float32)
SET enable_analyzer = '1';

DROP TABLE IF EXISTS dbpedia;

CREATE TABLE dbpedia
(
    id String,
    vec Array(Float32),
    INDEX vec_idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 1536, 'b1', 64, 128) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '2';

SELECT '-- INSERT 20 rows using the reinterpret() technique';

INSERT INTO dbpedia;

SELECT id
FROM dbpedia
ORDER BY cosineDistance(vec, (
        SELECT vec
        FROM dbpedia
        WHERE id = '<dbpedia:Honda>'
    )) ASC
LIMIT 4
SETTINGS use_skip_indexes = '0';

SELECT id
FROM dbpedia
ORDER BY cosineDistance(vec, (
        SELECT vec
        FROM dbpedia
        WHERE id = '<dbpedia:Honda>'
    )) ASC
LIMIT 4;

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM dbpedia
                ORDER BY cosineDistance(vec, (
                        SELECT vec
                        FROM dbpedia
                        WHERE id = '<dbpedia:Honda>'
                    )) ASC
                LIMIT 4
            ))
    )
WHERE `explain` LIKE '%vector_similarity%';

SELECT id
FROM dbpedia
ORDER BY cosineDistance(vec, (
        SELECT vec
        FROM dbpedia
        WHERE id = '<dbpedia:Pizza>'
    )) ASC
LIMIT 4;

SELECT id
FROM dbpedia
ORDER BY cosineDistance(vec, (
        SELECT vec
        FROM dbpedia
        WHERE id = '<dbpedia:Database_theory>'
    )) ASC
LIMIT 4;

-- Check that an index with binary quantization (1 bit / dimension) is smaller than an index with BFloat16 (2 bytes / dimension)
SELECT if(data_uncompressed_bytes < 20 * 1536 * 2, 'Good', toString(data_uncompressed_bytes))
FROM `system`.data_skipping_indices
WHERE database = currentDatabase()
    AND name = 'vec_idx';

DROP TABLE dbpedia;

-- Now test that a rescoring multiplier > 1.0 helps with search accuracy
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id Int32,
    vec Array(Float32),
    INDEX vec_idx vec TYPE vector_similarity('hnsw', 'cosineDistance', 8, 'b1', 64, 128) GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '1';

INSERT INTO tab;

-- Expect 1.
SELECT id
FROM tab
ORDER BY cosineDistance(vec, [-0.25, 0.25, 0.1, 0.1, 0.9, 0.9, 0.9, 0.9]) ASC
LIMIT 1
SETTINGS vector_search_with_rescoring = '0';

-- Expect 2
SELECT id
FROM tab
ORDER BY cosineDistance(vec, [-0.25, 0.25, 0.1, 0.1, 0.9, 0.9, 0.9, 0.9]) ASC
LIMIT 1
SETTINGS
    vector_search_with_rescoring = '1',
    vector_search_index_fetch_multiplier = '4';

DROP TABLE tab;