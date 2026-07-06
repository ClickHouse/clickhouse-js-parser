-- Tests the behavior of MergeTree setting 'alter_column_secondary_index_mode' with tables in compact and wide format
-- for ALTER TABLE {} DELETE and ALTER TABLE {} UPDATE
SET apply_mutations_on_fly = '0';

SET mutations_sync = '1';

SET alter_sync = '1';

DROP TABLE IF EXISTS test_compact;

DROP TABLE IF EXISTS test_wide;

CREATE TABLE test_compact
(
    a Int32,
    b Int32,
    c Int32,
    INDEX idx_minmax b TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS min_bytes_for_wide_part = '999999999';

CREATE TABLE test_wide
(
    a Int32,
    b Int32,
    c Int32,
    INDEX idx_minmax b TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO test_compact;

INSERT INTO test_wide;

ALTER TABLE test_compact MODIFY SETTING alter_column_secondary_index_mode = 'throw';

ALTER TABLE test_wide MODIFY SETTING alter_column_secondary_index_mode = 'throw';

-- ALTER TABLE UPDATE are expected to throw
ALTER TABLE test_compact UPDATE b = 3 WHERE b = 1; -- { serverError SUPPORT_IS_DISABLED }

ALTER TABLE test_compact DELETE WHERE b = 1; -- { serverError SUPPORT_IS_DISABLED }

ALTER TABLE test_wide UPDATE b = 3 WHERE b = 1; -- { serverError SUPPORT_IS_DISABLED }

ALTER TABLE test_wide DELETE WHERE b = 1; -- { serverError SUPPORT_IS_DISABLED }

ALTER TABLE test_compact MODIFY SETTING alter_column_secondary_index_mode = 'compatibility';

ALTER TABLE test_wide MODIFY SETTING alter_column_secondary_index_mode = 'compatibility';

INSERT INTO test_compact;

OPTIMIZE TABLE test_compact FINAL;

INSERT INTO test_wide;

OPTIMIZE TABLE test_wide FINAL;

SELECT
    'COMPACT BEFORE',
    *
FROM test_compact;

SELECT
    'WIDE BEFORE',
    *
FROM test_wide;

SELECT
    'COMPACT AFTER UPDATE',
    *
FROM test_compact;

SELECT
    'WIDE AFTER UPDATE',
    *
FROM test_wide;

SELECT
    table,
    name,
    'Emtpy : ' || if(marks_bytes = 0, 'true', 'false')
FROM `system`.data_skipping_indices
WHERE table = 'test_compact'
    AND database = currentDatabase()
    AND name = 'idx_minmax';

SELECT
    table,
    name,
    'Emtpy : ' || if(marks_bytes = 0, 'true', 'false')
FROM `system`.data_skipping_indices
WHERE table = 'test_wide'
    AND database = currentDatabase()
    AND name = 'idx_minmax';

ALTER TABLE test_compact DELETE WHERE b = 100;

SELECT
    'COMPACT AFTER DELETE',
    *
FROM test_compact;

ALTER TABLE test_wide DELETE WHERE b = 100;

SELECT
    'WIDE AFTER DELETE',
    *
FROM test_wide;

ALTER TABLE test_compact UPDATE b = 5 WHERE b = 3;

ALTER TABLE test_wide UPDATE b = 5 WHERE b = 3;

ALTER TABLE test_compact MODIFY SETTING alter_column_secondary_index_mode = 'drop';

ALTER TABLE test_wide MODIFY SETTING alter_column_secondary_index_mode = 'drop';

ALTER TABLE test_compact UPDATE b = 7 WHERE b = 5;

ALTER TABLE test_wide UPDATE b = 7 WHERE b = 5;

-- Alter of unrelated columns should only drop indices if needed (compact format is dropped, but wide is kept)
ALTER TABLE test_compact UPDATE c = 7 WHERE c = 6;

ALTER TABLE test_wide UPDATE c = 7 WHERE c = 6;

-- Delete over any column should drop indices since it requires changes
ALTER TABLE test_compact DELETE WHERE c = 7;

ALTER TABLE test_wide DELETE WHERE c = 7;