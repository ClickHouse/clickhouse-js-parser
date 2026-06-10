-- Tags: zookeeper
-- Settings allow_deprecated_syntax_for_merge_tree prevent to enable the is_deleted column
SET allow_deprecated_syntax_for_merge_tree = '0';

-- Test the bahaviour without the is_deleted column
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplacingMergeTree(version)
ORDER BY uid
SETTINGS allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO test (*);

SELECT *
FROM test FINAL
ORDER BY uid ASC;

OPTIMIZE TABLE test FINAL CLEANUP;

SELECT *
FROM test
ORDER BY uid ASC;

CREATE TABLE test
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplacingMergeTree(version)
ORDER BY uid
SETTINGS clean_deleted_rows = 'Always', allow_experimental_replacing_merge_with_cleanup = '1';

CREATE TABLE test
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplacingMergeTree(version, is_deleted)
ORDER BY uid
SETTINGS allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO test (*);

INSERT INTO test (*);

-- Expect d6 to be version=3 is_deleted=false
INSERT INTO test (*);

-- Insert previous version of 'd6' but only v=3 is_deleted=false will remain
INSERT INTO test (*);

-- insert d6 v=3 is_deleted=true (timestamp more recent so this version should be the one take into acount)
INSERT INTO test (*);

CREATE TABLE test
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplacingMergeTree(version, is_deleted)
ORDER BY uid
SETTINGS clean_deleted_rows = 'Always', allow_experimental_replacing_merge_with_cleanup = '1';

OPTIMIZE TABLE test FINAL;

-- d6 has to be removed since we set clean_deleted_rows as 'Always'
SELECT *
FROM test
WHERE is_deleted = 0
ORDER BY uid ASC;

ALTER TABLE test MODIFY SETTING clean_deleted_rows = 'Never';

DROP TABLE IF EXISTS testCleanupR1;

CREATE TABLE testCleanupR1
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{database}/tables/test_cleanup/', 'r1', version, is_deleted)
ORDER BY uid
SETTINGS allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO testCleanupR1 (*);

INSERT INTO testCleanupR1 (*);

INSERT INTO testCleanupR1 (*);

SYSTEM SYNC REPLICA testCleanupR1; -- Avoid "Cannot select parts for optimization: Entry for part all_2_2_0 hasn't been read from the replication log yet"

OPTIMIZE TABLE testCleanupR1 FINAL CLEANUP;

SELECT *
FROM testCleanupR1
ORDER BY uid ASC;

------------------------------
DROP TABLE IF EXISTS testSettingsR1;

CREATE TABLE testSettingsR1
(
    col1 String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{database}/tables/test_setting/', 'r1', version, is_deleted)
ORDER BY col1
SETTINGS clean_deleted_rows = 'Always', allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO testSettingsR1 (*);

SYSTEM SYNC REPLICA testSettingsR1; -- Avoid "Cannot select parts for optimization: Entry for part all_2_2_0 hasn't been read from the replication log yet"

OPTIMIZE TABLE testSettingsR1 FINAL;

SELECT *
FROM testSettingsR1
WHERE is_deleted = 0
ORDER BY col1 ASC;

-- is_deleted == 0/1
INSERT INTO test (*); -- { serverError INCORRECT_DATA }

-- checkis_deleted type
CREATE TABLE test
(
    uid String,
    version UInt32,
    is_deleted String
)
ENGINE = ReplacingMergeTree(version, is_deleted)
ORDER BY uid; -- { serverError BAD_TYPE_OF_FIELD }

CREATE TABLE test
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplacingMergeTree(version, is_deleted)
ORDER BY uid;

SELECT
    'no cleanup 1',
    *
FROM test FINAL
ORDER BY uid ASC;

SELECT
    'no cleanup 2',
    *
FROM test
ORDER BY uid ASC;

DROP TABLE test;

CREATE TABLE test
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{database}/tables/no_cleanup/', 'r1', version, is_deleted)
ORDER BY uid;

SELECT
    'no cleanup 3',
    *
FROM test FINAL
ORDER BY uid ASC;

SELECT
    'no cleanup 4',
    *
FROM test
ORDER BY uid ASC;

CREATE TABLE testMT
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = MergeTree()
ORDER BY uid
SETTINGS clean_deleted_rows = 'Always', allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO testMT (*);

OPTIMIZE TABLE testMT FINAL CLEANUP; -- { serverError CANNOT_ASSIGN_OPTIMIZE }

OPTIMIZE TABLE testMT FINAL;

SELECT *
FROM testMT
ORDER BY uid ASC;

CREATE TABLE testSummingMT
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = SummingMergeTree()
ORDER BY uid
SETTINGS clean_deleted_rows = 'Always', allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO testSummingMT (*);

OPTIMIZE TABLE testSummingMT FINAL CLEANUP; -- { serverError CANNOT_ASSIGN_OPTIMIZE }

OPTIMIZE TABLE testSummingMT FINAL;

SELECT *
FROM testSummingMT
ORDER BY uid ASC;

CREATE TABLE testAggregatingMT
(
    uid String,
    version UInt32,
    is_deleted UInt8
)
ENGINE = AggregatingMergeTree()
ORDER BY uid
SETTINGS clean_deleted_rows = 'Always', allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO testAggregatingMT (*);

OPTIMIZE TABLE testAggregatingMT FINAL CLEANUP; -- { serverError CANNOT_ASSIGN_OPTIMIZE }

OPTIMIZE TABLE testAggregatingMT FINAL;

SELECT *
FROM testAggregatingMT
ORDER BY uid ASC;

CREATE TABLE testCollapsingMT
(
    uid String,
    version UInt32,
    is_deleted UInt8,
    sign Int8
)
ENGINE = CollapsingMergeTree(sign)
ORDER BY uid
SETTINGS clean_deleted_rows = 'Always', allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO testCollapsingMT (*);

OPTIMIZE TABLE testCollapsingMT FINAL CLEANUP; -- { serverError CANNOT_ASSIGN_OPTIMIZE }

OPTIMIZE TABLE testCollapsingMT FINAL;

SELECT *
FROM testCollapsingMT
ORDER BY uid ASC;

CREATE TABLE testVersionedCMT
(
    uid String,
    version UInt32,
    is_deleted UInt8,
    sign Int8
)
ENGINE = VersionedCollapsingMergeTree(sign, version)
ORDER BY uid
SETTINGS clean_deleted_rows = 'Always', allow_experimental_replacing_merge_with_cleanup = '1';

INSERT INTO testVersionedCMT (*);

OPTIMIZE TABLE testVersionedCMT FINAL CLEANUP; -- { serverError CANNOT_ASSIGN_OPTIMIZE }

OPTIMIZE TABLE testVersionedCMT FINAL;

SELECT *
FROM testVersionedCMT
ORDER BY uid ASC;