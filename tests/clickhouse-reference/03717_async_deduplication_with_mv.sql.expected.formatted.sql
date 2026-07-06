-- Tags: no-parallel
DROP TABLE IF EXISTS `03717_table`;

CREATE TABLE `03717_table`
(
    id UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/03717_table', '1')
ORDER BY id
SETTINGS min_bytes_for_wide_part = '10000', min_rows_for_wide_part = '10000', serialization_info_version = 'basic', string_serialization_version = 'with_size_stream';

SYSTEM STOP MERGES `03717_table`;

DROP TABLE IF EXISTS `03717_mv_table_odd`;

CREATE TABLE `03717_mv_table_odd`
(
    value UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/03717_mv_table_odd', '1')
ORDER BY value
SETTINGS min_bytes_for_wide_part = '10000', min_rows_for_wide_part = '10000', serialization_info_version = 'basic', string_serialization_version = 'with_size_stream';

SYSTEM STOP MERGES `03717_mv_table_odd`;

DROP TABLE IF EXISTS `03717_mv_odd`;

CREATE MATERIALIZED VIEW `03717_mv_odd`
TO `03717_mv_table_odd`
AS
SELECT count() AS value
FROM `03717_table`
WHERE id % 2 = 1;

DROP TABLE IF EXISTS `03717_mv_table_even`;

CREATE TABLE `03717_mv_table_even`
(
    value UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/03717_mv_table_even', '1')
ORDER BY value
SETTINGS min_bytes_for_wide_part = '10000', min_rows_for_wide_part = '10000', serialization_info_version = 'basic', string_serialization_version = 'with_size_stream';

SYSTEM STOP MERGES `03717_mv_table_even`;

DROP TABLE IF EXISTS `03717_mv_even`;

CREATE MATERIALIZED VIEW `03717_mv_even`
TO `03717_mv_table_even`
AS
SELECT count() AS value
FROM `03717_table`
WHERE id % 2 = 0;

DROP TABLE IF EXISTS `03717_mv_table_all`;

CREATE TABLE `03717_mv_table_all`
(
    value UInt32
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/03717_mv_table_all', '1')
ORDER BY value
SETTINGS min_bytes_for_wide_part = '10000', min_rows_for_wide_part = '10000', serialization_info_version = 'basic', string_serialization_version = 'with_size_stream';

SYSTEM STOP MERGES `03717_mv_table_all`;

DROP TABLE IF EXISTS `03717_mv_all`;

CREATE MATERIALIZED VIEW `03717_mv_all`
TO `03717_mv_table_all`
AS
SELECT count() AS value
FROM `03717_table`;

SET async_insert = '1', insert_deduplicate = '1', async_insert_deduplicate = '1', wait_for_async_insert = '0', deduplicate_blocks_in_dependent_materialized_views = '1';

SET async_insert_use_adaptive_busy_timeout = '0', async_insert_busy_timeout_min_ms = '1000', async_insert_busy_timeout_max_ms = '5000';

SET max_block_size = '1';

SET max_insert_block_size = '1';

SET min_insert_block_size_rows = '0';

SET min_insert_block_size_bytes = '0';

INSERT INTO `03717_table`;

INSERT INTO `03717_table`;

INSERT INTO `03717_table`;

INSERT INTO `03717_table`;

--- those inserts might be in different async queue shards, they all would be flushed, but each shard produces separate part
SYSTEM FLUSH ASYNC INSERT QUEUE `03717_table`;

INSERT INTO `03717_table`;

SELECT
    '03717_table',
    *
FROM `03717_table`
ORDER BY `all` ASC;

SELECT
    '03717_mv_table_odd',
    sum(value)
FROM `03717_mv_table_odd`
ORDER BY `all` ASC;

SELECT
    '03717_mv_table_even',
    sum(value)
FROM `03717_mv_table_even`
ORDER BY `all` ASC;

SELECT
    '03717_mv_table_all',
    sum(value)
FROM `03717_mv_table_all`
ORDER BY `all` ASC;