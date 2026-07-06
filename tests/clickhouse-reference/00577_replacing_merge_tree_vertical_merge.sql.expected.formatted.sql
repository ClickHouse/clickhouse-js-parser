SET optimize_on_insert = '0';

DROP TABLE IF EXISTS tab_00577;

CREATE TABLE tab_00577
(
    date Date,
    version UInt64,
    val UInt64
)
ENGINE = ReplacingMergeTree(version)
ORDER BY date
PARTITION BY date
SETTINGS enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_rows_for_wide_part = '0', min_bytes_for_wide_part = '0', allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO tab_00577;

INSERT INTO tab_00577;

SELECT *
FROM tab_00577
ORDER BY version ASC;

OPTIMIZE TABLE tab_00577 FINAL CLEANUP;

SELECT *
FROM tab_00577;

DROP TABLE tab_00577;

DROP TABLE IF EXISTS testCleanupR1;

CREATE TABLE testCleanupR1
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{database}/tables/test_cleanup/', 'r1', version, is_deleted)
ORDER BY uid
SETTINGS enable_vertical_merge_algorithm = '1', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0', min_rows_for_wide_part = '0', min_bytes_for_wide_part = '0', allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO testCleanupR1 (*);

INSERT INTO testCleanupR1 (*);

INSERT INTO testCleanupR1 (*);

SYSTEM SYNC REPLICA testCleanupR1; -- Avoid "Cannot select parts for optimization: Entry for part all_2_2_0 hasn't been read from the replication log yet"

OPTIMIZE TABLE testCleanupR1 FINAL CLEANUP;

SELECT *
FROM testCleanupR1
ORDER BY uid ASC;