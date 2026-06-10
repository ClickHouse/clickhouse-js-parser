-- Tags: no-random-settings
DROP TABLE IF EXISTS t_merge_tree_index;

CREATE TABLE t_merge_tree_index
(
    a UInt64 CODEC(LZ4()),
    b UInt64 CODEC(LZ4()),
    s String CODEC(LZ4())
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS index_granularity = '3', min_bytes_for_wide_part = '0', ratio_of_defaults_for_sparse_serialization = 1., serialization_info_version = 'basic', compact_parts_max_granules_to_buffer = '1';

SYSTEM STOP MERGES t_merge_tree_index;

INSERT INTO t_merge_tree_index SELECT
    number % 5,
    number,
    'v' || toString(number * number)
FROM numbers(10);

INSERT INTO t_merge_tree_index SELECT
    number % 5,
    number,
    'v' || toString(number * number)
FROM numbers(10, 10);

SET output_format_pretty_named_tuples_as_json = '0';

SELECT *
FROM t_merge_tree_index
ORDER BY
    _part ASC,
    a ASC,
    b ASC;

SELECT *
FROM mergeTreeIndex(currentDatabase(), t_merge_tree_index)
ORDER BY
    part_name ASC,
    mark_number ASC
FORMAT PrettyCompactNoEscapesMonoBlock;

SELECT *
FROM mergeTreeIndex(currentDatabase(), t_merge_tree_index, with_marks = true)
ORDER BY
    part_name ASC,
    mark_number ASC
FORMAT PrettyCompactNoEscapesMonoBlock;

DROP TABLE t_merge_tree_index;

CREATE TABLE t_merge_tree_index
(
    a UInt64 CODEC(LZ4()),
    b UInt64 CODEC(LZ4()),
    s String CODEC(LZ4())
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS index_granularity = '3', min_bytes_for_wide_part = '1G', ratio_of_defaults_for_sparse_serialization = 1., serialization_info_version = 'basic', compact_parts_max_granules_to_buffer = '1';

INSERT INTO t_merge_tree_index SELECT
    number % 4,
    number,
    'v' || toString(number * number)
FROM numbers(10);

INSERT INTO t_merge_tree_index SELECT
    number % 4,
    number,
    'v' || toString(number * number)
FROM numbers(10, 10);