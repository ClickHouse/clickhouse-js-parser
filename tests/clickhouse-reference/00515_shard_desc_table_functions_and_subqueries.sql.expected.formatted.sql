-- Tags: shard
DROP TABLE IF EXISTS tab;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE tab
(
    date Date,
    val UInt64,
    val2 UInt8 DEFAULT 42,
    val3 UInt8 DEFAULT val2 + 1,
    val4 UInt64 ALIAS val
)
ENGINE = MergeTree(date, (date, val), 8192);

DESCRIBE TABLE tab;

DESCRIBE TABLE tab;

DESCRIBE TABLE remote('127.0.0.2', currentDatabase(), tab);

DESCRIBE TABLE remote('127.0.0.2', currentDatabase(), tab);

DESCRIBE TABLE (SELECT 1);

DESCRIBE TABLE (SELECT 1);

DESCRIBE TABLE (SELECT *
FROM `system`.numbers);