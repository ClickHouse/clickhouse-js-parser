-- Tags: no-parallel, no-object-storage
-- no-parallel -- for flaky check and to avoid "Removing leftovers from table" (for other tables)
-- Temporarily skip warning 'table was created by another server at the same moment, will retry'
SET send_logs_level = 'error';

SET database_atomic_wait_for_drop_and_detach_synchronously = '1';

DROP TABLE IF EXISTS rep_fsync_r1;

DROP TABLE IF EXISTS rep_fsync_r2;

CREATE TABLE rep_fsync_r1
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r1')
ORDER BY key;

CREATE TABLE rep_fsync_r2
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r2')
ORDER BY key;

INSERT INTO rep_fsync_r1;

SYSTEM SYNC REPLICA rep_fsync_r2;

SELECT *
FROM rep_fsync_r2;

OPTIMIZE TABLE rep_fsync_r1 FINAL;

DROP TABLE rep_fsync_r1;

DROP TABLE rep_fsync_r2;

CREATE TABLE rep_fsync_r1
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r1')
ORDER BY key
SETTINGS min_rows_for_wide_part = '2', fsync_after_insert = '1';

CREATE TABLE rep_fsync_r2
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r2')
ORDER BY key
SETTINGS min_rows_for_wide_part = '2', fsync_after_insert = '1';

CREATE TABLE rep_fsync_r1
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r1')
ORDER BY key
SETTINGS min_rows_for_wide_part = '2', fsync_after_insert = '1', fsync_part_directory = '1';

CREATE TABLE rep_fsync_r2
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r2')
ORDER BY key
SETTINGS min_rows_for_wide_part = '2', fsync_after_insert = '1', fsync_part_directory = '1';

CREATE TABLE rep_fsync_r1
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r1')
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_after_insert = '1';

CREATE TABLE rep_fsync_r2
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r2')
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_after_insert = '1';

CREATE TABLE rep_fsync_r1
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r1')
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_after_insert = '1', fsync_part_directory = '1';

CREATE TABLE rep_fsync_r2
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r2')
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_after_insert = '1', fsync_part_directory = '1';

CREATE TABLE rep_fsync_r1
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r1')
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_part_directory = '1', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0';

CREATE TABLE rep_fsync_r2
(
    key Int
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/rep_fsync', 'r2')
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', fsync_part_directory = '1', enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0';

INSERT INTO rep_fsync_r2;

SELECT *
FROM rep_fsync_r2
ORDER BY key ASC;

-- vertical merge does not supports deduplicate, hence no FINAL
OPTIMIZE TABLE rep_fsync_r1;