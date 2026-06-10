DROP TABLE IF EXISTS old_school_table;

CREATE TABLE old_school_table
(
    key UInt64,
    value String
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS index_granularity_bytes = '0', enable_mixed_granularity_parts = '0', min_bytes_for_wide_part = '0', vertical_merge_algorithm_min_rows_to_activate = '1', vertical_merge_algorithm_min_columns_to_activate = '1';

INSERT INTO old_school_table;

INSERT INTO old_school_table;

OPTIMIZE TABLE old_school_table FINAL;

SELECT *
FROM old_school_table
ORDER BY key ASC;

ALTER TABLE old_school_table MODIFY SETTING vertical_merge_algorithm_min_rows_to_activate = '10000', vertical_merge_algorithm_min_columns_to_activate = '10000';