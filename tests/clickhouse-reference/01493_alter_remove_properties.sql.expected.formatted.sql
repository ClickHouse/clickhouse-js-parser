DROP TABLE IF EXISTS prop_table;

CREATE TABLE prop_table
(
    column_default UInt64 DEFAULT 42,
    column_materialized UInt64 MATERIALIZED column_default * 42,
    column_alias UInt64 ALIAS column_default + 1,
    column_codec String CODEC(ZSTD(10)),
    column_comment Date COMMENT 'Some comment',
    column_ttl UInt64 TTL column_comment + toIntervalMonth(1)
)
ENGINE = MergeTree()
ORDER BY tuple()
TTL column_comment + toIntervalMonth(2);

SHOW CREATE TABLE prop_table;

SYSTEM STOP TTL MERGES prop_table;

INSERT INTO prop_table (column_codec, column_comment, column_ttl);

SELECT
    column_default,
    column_materialized,
    column_alias,
    column_codec,
    column_comment,
    column_ttl
FROM prop_table;

ALTER TABLE prop_table MODIFY COLUMN column_comment REMOVE COMMENT;

ALTER TABLE prop_table MODIFY COLUMN column_codec REMOVE CODEC;

ALTER TABLE prop_table MODIFY COLUMN column_alias REMOVE ALIAS;

INSERT INTO prop_table (column_alias, column_codec, column_comment, column_ttl);

SELECT
    column_default,
    column_materialized,
    column_alias,
    column_codec,
    column_comment,
    column_ttl
FROM prop_table
ORDER BY column_ttl ASC;

ALTER TABLE prop_table MODIFY COLUMN column_materialized REMOVE MATERIALIZED;

INSERT INTO prop_table (column_materialized, column_alias, column_codec, column_comment, column_ttl);

ALTER TABLE prop_table MODIFY COLUMN column_default REMOVE DEFAULT;

INSERT INTO prop_table (column_materialized, column_alias, column_codec, column_comment, column_ttl);

ALTER TABLE prop_table REMOVE TTL;

ALTER TABLE prop_table MODIFY COLUMN column_ttl REMOVE TTL;

SYSTEM START TTL MERGES prop_table;

OPTIMIZE TABLE prop_table FINAL;

SELECT COUNT()
FROM prop_table;