-- Tags: no-random-merge-tree-settings
----- Group of very similar simple tests ------
SELECT '----HORIZONTAL MERGE TESTS----';

DROP TABLE IF EXISTS zero_rows_per_granule;

CREATE TABLE zero_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '20', min_index_granularity_bytes = '10', write_final_mark = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

INSERT INTO zero_rows_per_granule (p, k, v1, v2);

SELECT COUNT(*)
FROM zero_rows_per_granule;

SELECT DISTINCT marks
FROM `system`.parts
WHERE table = 'zero_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1;

INSERT INTO zero_rows_per_granule (p, k, v1, v2);

OPTIMIZE TABLE zero_rows_per_granule FINAL;

DROP TABLE IF EXISTS two_rows_per_granule;

CREATE TABLE two_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '40', min_index_granularity_bytes = '10', write_final_mark = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

INSERT INTO two_rows_per_granule (p, k, v1, v2);

SELECT COUNT(*)
FROM two_rows_per_granule;

SELECT DISTINCT marks
FROM `system`.parts
WHERE table = 'two_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1;

INSERT INTO two_rows_per_granule (p, k, v1, v2);

OPTIMIZE TABLE two_rows_per_granule FINAL;

DROP TABLE IF EXISTS four_rows_per_granule;

CREATE TABLE four_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '110', min_index_granularity_bytes = '10', write_final_mark = '0', min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0';

INSERT INTO four_rows_per_granule (p, k, v1, v2);

SELECT COUNT(*)
FROM four_rows_per_granule;

SELECT DISTINCT marks
FROM `system`.parts
WHERE table = 'four_rows_per_granule'
    AND database = currentDatabase()
    AND active = 1;

DETACH TABLE four_rows_per_granule;

ATTACH TABLE four_rows_per_granule;

INSERT INTO four_rows_per_granule (p, k, v1, v2);

OPTIMIZE TABLE four_rows_per_granule FINAL;

DROP TABLE IF EXISTS huge_granularity_small_blocks;

CREATE TABLE huge_granularity_small_blocks
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '1000000', write_final_mark = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

INSERT INTO huge_granularity_small_blocks (p, k, v1, v2);

SELECT COUNT(*)
FROM huge_granularity_small_blocks;

SELECT DISTINCT marks
FROM `system`.parts
WHERE table = 'huge_granularity_small_blocks'
    AND database = currentDatabase()
    AND active = 1;

INSERT INTO huge_granularity_small_blocks (p, k, v1, v2);

DETACH TABLE huge_granularity_small_blocks;

ATTACH TABLE huge_granularity_small_blocks;

OPTIMIZE TABLE huge_granularity_small_blocks FINAL;

DROP TABLE IF EXISTS adaptive_granularity_alter;

CREATE TABLE adaptive_granularity_alter
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '110', min_index_granularity_bytes = '100', write_final_mark = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

INSERT INTO adaptive_granularity_alter (p, k, v1, v2);

SELECT COUNT(*)
FROM adaptive_granularity_alter;

SELECT DISTINCT marks
FROM `system`.parts
WHERE table = 'adaptive_granularity_alter'
    AND database = currentDatabase()
    AND active = 1;

OPTIMIZE TABLE adaptive_granularity_alter FINAL;

ALTER TABLE adaptive_granularity_alter MODIFY COLUMN v1 Int16;

DETACH TABLE adaptive_granularity_alter;

ATTACH TABLE adaptive_granularity_alter;

INSERT INTO adaptive_granularity_alter (p, k, v1, v2);

ALTER TABLE adaptive_granularity_alter MODIFY COLUMN v2 String;

INSERT INTO adaptive_granularity_alter (p, k, v1, v2);

SELECT
    k,
    v2
FROM adaptive_granularity_alter
WHERE k >= 100
    OR k = 42
ORDER BY k ASC;

SELECT sum(marks)
FROM `system`.parts
WHERE table = 'adaptive_granularity_alter'
    AND database = currentDatabase()
    AND active = 1;

CREATE TABLE zero_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '20', min_index_granularity_bytes = '10', write_final_mark = '0', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

CREATE TABLE two_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '40', min_index_granularity_bytes = '10', write_final_mark = '0', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

CREATE TABLE four_rows_per_granule
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '110', min_index_granularity_bytes = '10', write_final_mark = '0', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

CREATE TABLE huge_granularity_small_blocks
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '1000000', write_final_mark = '0', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';

CREATE TABLE adaptive_granularity_alter
(
    p Date,
    k UInt64,
    v1 UInt64,
    v2 Int64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY toYYYYMM(p)
SETTINGS index_granularity_bytes = '110', min_index_granularity_bytes = '100', write_final_mark = '0', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0';