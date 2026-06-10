-- Tags: no-replicated-database
-- ^ due to the usage of ON CLUSTER queries
SET distributed_ddl_output_mode = 'none', enable_analyzer = true;

DROP TABLE IF EXISTS source, mview;

CREATE TABLE source
(
    timestamp DateTime,
    card_id UInt64,
    _id String
)
ENGINE = MergeTree()
ORDER BY _id
PARTITION BY toYYYYMM(timestamp)
TTL toDateTime(timestamp + toIntervalDay(7));

CREATE MATERIALIZED VIEW mview ON CLUSTER test_shard_localhost
ENGINE = SummingMergeTree()
ORDER BY (day, card_id)
AS
SELECT
    toDate(timestamp) AS day,
    card_id,
    count(*) AS card_view
FROM source
GROUP BY (day, card_id);

DROP TABLE mview;

CREATE MATERIALIZED VIEW mview ON CLUSTER test_shard_localhost
(
    day Date,
    card_id UInt64,
    card_view Int64
)
ENGINE = SummingMergeTree()
ORDER BY (day, card_id)
AS
SELECT
    toDate(timestamp) AS day,
    card_id,
    count(*) AS card_view
FROM source
GROUP BY (day, card_id);

ALTER TABLE source ON CLUSTER test_shard_localhost MODIFY SETTING ttl_only_drop_parts = '1';

DROP TABLE IF EXISTS mview, source;