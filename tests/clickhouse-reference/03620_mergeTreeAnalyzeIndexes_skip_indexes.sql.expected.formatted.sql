-- Tags: no-random-merge-tree-settings
-- - no-random-merge-tree-settings -- may change amount of granulas
DROP TABLE IF EXISTS with_skip_index;

CREATE TABLE with_skip_index
(
    key Int,
    value Int,
    INDEX value_idx value TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO with_skip_index SELECT
    number,
    number * 100
FROM numbers(1000000.);

-- { echo }
SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), 'with_skip_index', value > 0);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), 'with_skip_index', value > 5000000);

SELECT *
FROM mergeTreeAnalyzeIndexes(currentDatabase(), 'with_skip_index', value > 100000000);