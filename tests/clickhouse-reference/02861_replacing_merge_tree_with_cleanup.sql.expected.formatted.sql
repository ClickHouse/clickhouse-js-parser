DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplacingMergeTree(version, is_deleted)
ORDER BY uid
SETTINGS vertical_merge_algorithm_min_rows_to_activate = '1', vertical_merge_algorithm_min_columns_to_activate = '0', min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1', allow_experimental_replacing_merge_with_cleanup = '1';

-- Expect d6 to be version=3 is_deleted=false
INSERT INTO test (*);

-- Insert previous version of 'd6' but only v=3 is_deleted=false will remain
INSERT INTO test (*);

OPTIMIZE TABLE test FINAL CLEANUP;

SELECT *
FROM test
ORDER BY uid ASC;

-- insert d6 v=3 is_deleted=true (timestamp more recent so this version should be the one take into acount)
INSERT INTO test (*);