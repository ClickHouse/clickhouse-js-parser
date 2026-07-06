DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    key Int,
    value Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS merge_selector_base = '1000', index_granularity = '8192', index_granularity_bytes = 10000000000., min_bytes_for_wide_part = 1000000000. AS
SELECT
    *,
    * + 1000000
FROM numbers(100000)
SETTINGS max_insert_threads = '1';

DROP TABLE IF EXISTS keys_1;

CREATE TABLE keys_1
(
    key Int
)
ENGINE = Log() AS
SELECT *
FROM numbers(10);

DROP TABLE IF EXISTS keys_2;

CREATE TABLE keys_2
(
    key Int
)
ENGINE = Log() AS
SELECT *
FROM numbers(10000, 10);

-- { echo }
SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key IN (
        SELECT key
        FROM data
        ORDER BY key ASC
        LIMIT 10
    ));

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key IN (
        SELECT key
        FROM data
        ORDER BY key DESC
        LIMIT 10
    ));

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key IN (keys_1));

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key IN (keys_2));