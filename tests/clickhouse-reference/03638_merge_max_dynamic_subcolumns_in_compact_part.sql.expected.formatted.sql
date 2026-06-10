DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 4)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '100G', merge_max_dynamic_subcolumns_in_compact_part = '2';

INSERT INTO test SELECT '{"a" : 42, "b" : 42, "c" : 42, "d" : 42, "e" : 42, "f" : 42}';

SELECT
    JSONDynamicPaths(json),
    JSONSharedDataPaths(json)
FROM test;

OPTIMIZE TABLE test FINAL;

SELECT
    JSONDynamicPaths(json),
    JSONSharedDataPaths(json)
FROM test
LIMIT 1;

DROP TABLE test;

CREATE TABLE test
(
    x UInt32,
    json JSON(max_dynamic_paths = 4)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '100G', merge_max_dynamic_subcolumns_in_compact_part = '2', vertical_merge_algorithm_min_rows_to_activate = '1', vertical_merge_algorithm_min_columns_to_activate = '1';

INSERT INTO test SELECT
    42,
    '{"a" : 42, "b" : 42, "c" : 42, "d" : 42, "e" : 42, "f" : 42}';