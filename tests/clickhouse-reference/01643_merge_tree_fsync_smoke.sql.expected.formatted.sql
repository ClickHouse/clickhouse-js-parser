-- Tags: no-object-storage, no-fasttest
-- no-fasttest: It can be slow
DROP TABLE IF EXISTS data_01643;

CREATE TABLE data_01643
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO data_01643;

SELECT *
FROM data_01643;

OPTIMIZE TABLE data_01643 FINAL;

DROP TABLE data_01643;

CREATE TABLE data_01643
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS min_rows_for_wide_part = '2', fsync_after_insert = '1';

CREATE TABLE data_01643
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS min_rows_for_wide_part = '2', fsync_after_insert = '1', fsync_part_directory = '1';

CREATE TABLE data_01643
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_after_insert = '1';

CREATE TABLE data_01643
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_after_insert = '1', fsync_part_directory = '1';

CREATE TABLE data_01643
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_part_directory = '1', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0';

INSERT INTO data_01643;

SELECT *
FROM data_01643
ORDER BY key ASC;

-- vertical merge does not supports deduplicate, hence no FINAL
OPTIMIZE TABLE data_01643;