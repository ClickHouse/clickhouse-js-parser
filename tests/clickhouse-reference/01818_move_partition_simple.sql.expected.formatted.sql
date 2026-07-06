DROP TABLE IF EXISTS main_table_01818;

DROP TABLE IF EXISTS tmp_table_01818;

CREATE TABLE main_table_01818
(
    id UInt32,
    advertiser_id String,
    campaign_id String,
    name String,
    budget Float64,
    budget_mode String,
    landing_type String,
    status String,
    modify_time String,
    campaign_type String,
    campaign_create_time DateTime,
    campaign_modify_time DateTime,
    create_time DateTime,
    update_time DateTime
)
ENGINE = MergeTree()
ORDER BY campaign_id
PARTITION BY advertiser_id
SETTINGS index_granularity = '8192';

CREATE TABLE tmp_table_01818
(
    id UInt32,
    advertiser_id String,
    campaign_id String,
    name String,
    budget Float64,
    budget_mode String,
    landing_type String,
    status String,
    modify_time String,
    campaign_type String,
    campaign_create_time DateTime,
    campaign_modify_time DateTime,
    create_time DateTime,
    update_time DateTime
)
ENGINE = MergeTree()
ORDER BY campaign_id
PARTITION BY advertiser_id
SETTINGS index_granularity = '8192';

INSERT INTO main_table_01818 SELECT
    1 AS id,
    'ClickHouse' AS advertiser_id,
    * EXCEPT (id, advertiser_id)
FROM generateRandom('`id` UInt32,\n    `advertiser_id` String,\n    `campaign_id` String,\n    `name` String,\n    `budget` Float64,\n    `budget_mode` String,\n    `landing_type` String,\n    `status` String,\n    `modify_time` String,\n    `campaign_type` String,\n    `campaign_create_time` DateTime,\n    `campaign_modify_time` DateTime,\n    `create_time` DateTime,\n    `update_time` DateTime', 10, 10, 10)
LIMIT 100;

INSERT INTO tmp_table_01818 SELECT
    2 AS id,
    'Database' AS advertiser_id,
    * EXCEPT (id, advertiser_id)
FROM generateRandom('`id` UInt32,\n    `advertiser_id` String,\n    `campaign_id` String,\n    `name` String,\n    `budget` Float64,\n    `budget_mode` String,\n    `landing_type` String,\n    `status` String,\n    `modify_time` String,\n    `campaign_type` String,\n    `campaign_create_time` DateTime,\n    `campaign_modify_time` DateTime,\n    `create_time` DateTime,\n    `update_time` DateTime', 10, 10, 10)
LIMIT 100;

INSERT INTO tmp_table_01818 SELECT
    3 AS id,
    'ClickHouse' AS advertiser_id,
    * EXCEPT (id, advertiser_id)
FROM generateRandom('`id` UInt32,\n    `advertiser_id` String,\n    `campaign_id` String,\n    `name` String,\n    `budget` Float64,\n    `budget_mode` String,\n    `landing_type` String,\n    `status` String,\n    `modify_time` String,\n    `campaign_type` String,\n    `campaign_create_time` DateTime,\n    `campaign_modify_time` DateTime,\n    `create_time` DateTime,\n    `update_time` DateTime', 10, 10, 10)
LIMIT 100;

SELECT
    'ALL tmp_table_01818',
    count()
FROM tmp_table_01818;

SELECT
    'ALL main_table_01818',
    count()
FROM main_table_01818;

SELECT
    'tmp_table_01818',
    count()
FROM tmp_table_01818
WHERE advertiser_id = 'ClickHouse';

SELECT
    'main_table_01818',
    count()
FROM main_table_01818
WHERE advertiser_id = 'ClickHouse';

ALTER TABLE tmp_table_01818 MOVE PARTITION 'ClickHouse' TO TABLE main_table_01818;