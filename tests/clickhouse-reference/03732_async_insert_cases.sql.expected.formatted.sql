SET async_insert = '1';

SET wait_for_async_insert = '0';

SET async_insert_deduplicate = '1';

SET deduplicate_blocks_in_dependent_materialized_views = '1';

-- turn off adaptive busy timeout to make test stable
SET async_insert_use_adaptive_busy_timeout = '0', async_insert_busy_timeout_min_ms = '1000', async_insert_busy_timeout_max_ms = '5000';

CREATE TABLE `03732_table`
(
    id UInt32,
    name String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test/{database}/03732_table', 'replica1')
ORDER BY id;

CREATE TABLE `03732_table_mv_dst`
(
    id UInt32,
    name String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test/{database}/03732_table_mv_dst', 'replica1')
ORDER BY id;

CREATE MATERIALIZED VIEW `03732_table_mv`
TO `03732_table_mv_dst`
AS
SELECT *
FROM `03732_table`;

INSERT INTO `03732_table`;

SYSTEM FLUSH ASYNC INSERT QUEUE `03732_table`;

SELECT count(*)
FROM `03732_table`; -- Expecting 3

SELECT count(*)
FROM `03732_table_mv_dst`; -- Expecting 3

INSERT INTO `03732_table`;

TRUNCATE TABLE `03732_table`;

TRUNCATE TABLE `03732_table_mv_dst`;

INSERT INTO `03732_table` SETTINGS insert_deduplication_token = 'token1';

INSERT INTO `03732_table` SETTINGS insert_deduplication_token = 'token1';

INSERT INTO `03732_table` SETTINGS insert_deduplication_token = 'token2';

CREATE TABLE `03732_table_join`
(
    id UInt32,
    surname String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test/{database}/03732_table_join', 'replica1')
ORDER BY id;

INSERT INTO `03732_table_join`;

INSERT INTO `03732_table_join`;

SYSTEM FLUSH ASYNC INSERT QUEUE `03732_table_join`;

CREATE TABLE `03732_table_join_mv_dst`
(
    id UInt32,
    name String,
    surname String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/test/{database}/03732_table_join_mv_dst', 'replica1')
ORDER BY id;

CREATE MATERIALIZED VIEW `03732_table_join_mv`
TO `03732_table_join_mv_dst`
AS
SELECT
    t1.id AS id,
    t1.name AS name,
    t2.surname AS surname
FROM
    `03732_table` AS t1
INNER JOIN `03732_table_join` AS t2
    USING (id);

SELECT count(*)
FROM `03732_table_join_mv`; -- Expecting 3

SELECT *
FROM `03732_table_join_mv`
ORDER BY id ASC;