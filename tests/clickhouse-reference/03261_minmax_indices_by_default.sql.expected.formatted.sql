SET mutations_sync = '2';

DROP TABLE IF EXISTS tbl1;

DROP TABLE IF EXISTS tbl2;

DROP TABLE IF EXISTS tbl3;

DROP TABLE IF EXISTS tbl4;

DROP TABLE IF EXISTS tbl5;

CREATE TABLE tbl1
(
    key Int,
    x Int,
    y Int,
    INDEX x_idx x TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_numeric_columns = true, add_minmax_index_for_string_columns = true, add_minmax_index_for_temporal_columns = true, index_granularity = '8192', index_granularity_bytes = '10485760';

INSERT INTO tbl1;

-- Expect x_idx and two implicit minmax indices
SELECT
    name,
    type,
    expr,
    data_compressed_bytes
FROM `system`.data_skipping_indices
WHERE table = 'tbl1'
    AND database = currentDatabase();

-- Settings 'add_minmax_index_for_*_columns' cannot be changed after table creation
ALTER TABLE tbl1 MODIFY SETTING add_minmax_index_for_numeric_columns = false; -- { serverError READONLY_SETTING }

ALTER TABLE tbl1 MODIFY SETTING add_minmax_index_for_string_columns = false; -- { serverError READONLY_SETTING }

ALTER TABLE tbl1 MODIFY SETTING add_minmax_index_for_temporal_columns = false; -- { serverError READONLY_SETTING }

ALTER TABLE tbl1 RESET SETTING add_minmax_index_for_numeric_columns; -- { serverError READONLY_SETTING }

ALTER TABLE tbl1 RESET SETTING add_minmax_index_for_string_columns; -- { serverError READONLY_SETTING }

ALTER TABLE tbl1 RESET SETTING add_minmax_index_for_temporal_columns; -- { serverError READONLY_SETTING }

ALTER TABLE tbl1 ADD COLUMN n Int;

ALTER TABLE tbl1 MATERIALIZE INDEX auto_minmax_index_n;

ALTER TABLE tbl1 DROP COLUMN n;

ALTER TABLE tbl1 ADD COLUMN s String;

ALTER TABLE tbl1 ADD COLUMN t String;

ALTER TABLE tbl1 DROP COLUMN t;

ALTER TABLE tbl1 RENAME COLUMN s TO t;

ALTER TABLE tbl1 ADD COLUMN dt DateTime64(9, 'UTC');

ALTER TABLE tbl1 ADD COLUMN dt2 DateTime;

ALTER TABLE tbl1 DROP COLUMN dt2;

ALTER TABLE tbl1 RENAME COLUMN dt TO dt2;

ALTER TABLE tbl1 ADD COLUMN d Date;

ALTER TABLE tbl1 ADD COLUMN d32 Date32;

ALTER TABLE tbl1 ADD COLUMN time Time;

ALTER TABLE tbl1 ADD COLUMN time64 Time64;

-- Check that users cannot create explicit minmax indices with the names of internal minmax indices
CREATE TABLE tbl2
(
    key Int,
    x Int,
    y Int,
    INDEX auto_minmax_index_x x TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_numeric_columns = true; -- { serverError BAD_ARGUMENTS }

CREATE TABLE tbl2
(
    key Int,
    x Int,
    y Int,
    INDEX auto_minmax_index_x x TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_numeric_columns = '0';

CREATE TABLE tbl3
(
    key Int,
    x Int,
    y Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_numeric_columns = '0';

ALTER TABLE tbl3 ADD INDEX auto_minmax_index_y y TYPE minmax() GRANULARITY 1;

CREATE TABLE tbl4
(
    key Int,
    x Int,
    y Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_string_columns = true;

ALTER TABLE tbl4 ADD INDEX auto_minmax_index_y y TYPE minmax() GRANULARITY 1; -- { serverError BAD_ARGUMENTS, ILLEGAL_COLUMN }

CREATE TABLE tbl5
(
    key Int,
    x Int,
    y Int
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_temporal_columns = true;

ALTER TABLE tbl5 ADD INDEX auto_minmax_index_y y TYPE minmax() GRANULARITY 1; -- { serverError BAD_ARGUMENTS, ILLEGAL_COLUMN }

CREATE TABLE tbl6
(
    key Int,
    x Int,
    y Int,
    s String,
    INDEX x_idx x TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_numeric_columns = false, add_minmax_index_for_string_columns = false, add_minmax_index_for_temporal_columns = false;

SELECT
    name,
    type,
    expr,
    data_compressed_bytes
FROM `system`.data_skipping_indices
WHERE table = 'tbl6'
    AND database = currentDatabase();

-- check that ATTACH of such tables will not throw "uses a reserved index name" error
DETACH TABLE tbl1;

ATTACH TABLE tbl1;

DROP TABLE tbl1;

DROP TABLE tbl2;

DROP TABLE tbl3;

DROP TABLE tbl4;

DROP TABLE tbl5;

DROP TABLE tbl6;