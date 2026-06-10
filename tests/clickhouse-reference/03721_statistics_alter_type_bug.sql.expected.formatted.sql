-- Tags: no-fasttest
DROP TABLE IF EXISTS column_modify_test;

SET use_statistics = '1';

CREATE TABLE column_modify_test
(
    id UInt64,
    val String,
    other_col UInt64
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '0', auto_statistics_types = 'uniq,countmin';

INSERT INTO column_modify_test;

ALTER TABLE column_modify_test MODIFY COLUMN val Nullable(String);

ALTER TABLE column_modify_test UPDATE other_col = 1 WHERE id = 1 SETTINGS mutations_sync = '1';

SELECT
    *,
    throwIf(val != 'one') AS issue
FROM column_modify_test
WHERE id = 1
FORMAT NULL;

DROP TABLE column_modify_test;

CREATE TABLE column_modify_test
(
    id UInt64,
    val Nullable(String),
    other_col UInt64
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '0', auto_statistics_types = 'uniq,countmin';

ALTER TABLE column_modify_test MODIFY COLUMN val String DEFAULT '';