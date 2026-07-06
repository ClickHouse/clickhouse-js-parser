-- Tags: no-random-merge-tree-settings
-- - no-random-merge-tree-settings -- may change amount of granulas
-- add_minmax_index_for_numeric_columns=0: Changes the plan (the index on value would filter out value = 0)
DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    key Int,
    value Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_numeric_columns = '0';

INSERT INTO data SELECT
    *,
    * + 1000000
FROM numbers(100000);

-- { echo }
SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key = 8193);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key >= 8193);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key = 8192 + 1
    OR key = 8192 * 3 + 1);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key = 8192 + 1
    OR key = 8192 * 5 + 1);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key = 8193, 'all_1_1_0');

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key = 8193, 'no_such_part');

-- Columns not from PK is allowed and ignored.
SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, value = 0);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key = 8193
    AND value = 0);

-- Set
SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data, key IN (8193, 16385));