-- https://github.com/ClickHouse/ClickHouse/issues/93817
DROP TABLE IF EXISTS data_add_minmax_index_for_numeric_columns;

CREATE TABLE data_add_minmax_index_for_numeric_columns
(
    key Int,
    value Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS merge_selector_base = '1000', index_granularity = '8192', index_granularity_bytes = 10000000000., min_bytes_for_wide_part = 1000000000., add_minmax_index_for_numeric_columns = '1' AS
SELECT
    *,
    * + 1000000
FROM numbers(100000)
SETTINGS max_insert_threads = '1';

-- { echoOn }
SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data_add_minmax_index_for_numeric_columns, key = 8193);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data_add_minmax_index_for_numeric_columns, key = 8193, 'no_such_part');

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), data_add_minmax_index_for_numeric_columns, key = 8193, '.*|no_such_part'); -- { echoOff }