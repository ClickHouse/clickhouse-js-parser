-- Tags: long, no-replicated-database, no-fasttest
-- Tag no-replicated-database: Unsupported type of ALTER query
-- Suppress error logs because `temporary_directories_lifetime` is 1 seconds (the default value is 1 day).
-- And when a part is duplicated, it will be removed. However, because `temporary_directories_lifetime` is 1 seconds (the default value is 1 day), 
-- it might be removed by `MergeTreeData::clearOldTemporaryDirectories` thread.
-- `IMergeTreeDataPart::removeIfNeeded` will fail to remove the part, causing it to have some error logs.
SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS merge_tree_deduplication;

CREATE TABLE merge_tree_deduplication
(
    key UInt64,
    value String,
    part UInt8 DEFAULT 77
)
ENGINE = MergeTree()
ORDER BY key
PARTITION BY part
SETTINGS non_replicated_deduplication_window = '3', disk = 's3_plain_rewritable';

SYSTEM STOP MERGES merge_tree_deduplication;

INSERT INTO merge_tree_deduplication (key, value);

SELECT
    key,
    value
FROM merge_tree_deduplication;

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

SELECT
    key,
    value
FROM merge_tree_deduplication
ORDER BY key ASC;

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

INSERT INTO merge_tree_deduplication (key, value);

ALTER TABLE merge_tree_deduplication DROP PART '77_9_9_0'; -- some old part

SELECT
    key,
    value
FROM merge_tree_deduplication
WHERE key = 10;

ALTER TABLE merge_tree_deduplication DROP PART '77_13_13_0'; -- fresh part

SELECT
    key,
    value
FROM merge_tree_deduplication
WHERE key = 12;

DETACH TABLE merge_tree_deduplication;

ATTACH TABLE merge_tree_deduplication;

OPTIMIZE TABLE merge_tree_deduplication FINAL;

INSERT INTO merge_tree_deduplication (key, value, part);

ALTER TABLE merge_tree_deduplication DROP PARTITION 77;

SELECT
    part,
    key,
    value
FROM merge_tree_deduplication
ORDER BY
    key ASC,
    part ASC;

-- Alters....
ALTER TABLE merge_tree_deduplication MODIFY SETTING non_replicated_deduplication_window = '2';

INSERT INTO merge_tree_deduplication (key, value, part);

INSERT INTO merge_tree_deduplication (key, value, part);

INSERT INTO merge_tree_deduplication (key, value, part);

SELECT *
FROM merge_tree_deduplication
WHERE part = 33
ORDER BY key ASC;

ALTER TABLE merge_tree_deduplication MODIFY SETTING non_replicated_deduplication_window = '0';

ALTER TABLE merge_tree_deduplication MODIFY SETTING non_replicated_deduplication_window = '3';

INSERT INTO merge_tree_deduplication (key, value, part);

INSERT INTO merge_tree_deduplication (key, value, part);

INSERT INTO merge_tree_deduplication (key, value, part);

INSERT INTO merge_tree_deduplication (key, value, part);

SELECT *
FROM merge_tree_deduplication
WHERE part = 44
ORDER BY key ASC;

DROP TABLE IF EXISTS merge_tree_no_deduplication;

CREATE TABLE merge_tree_no_deduplication
(
    key UInt64,
    value String
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS disk = 's3_plain_rewritable';

INSERT INTO merge_tree_no_deduplication (key, value);

SELECT *
FROM merge_tree_no_deduplication
ORDER BY key ASC;

ALTER TABLE merge_tree_no_deduplication MODIFY SETTING non_replicated_deduplication_window = '3';

INSERT INTO merge_tree_no_deduplication (key, value);

INSERT INTO merge_tree_no_deduplication (key, value);

DETACH TABLE merge_tree_no_deduplication;

ATTACH TABLE merge_tree_no_deduplication;

INSERT INTO merge_tree_no_deduplication (key, value);