-- https://github.com/ClickHouse/ClickHouse/issues/44668
CREATE TABLE temp
(
    id UInt64,
    field1 UUID,
    field2 UUID,
    field3 Int64,
    field4 Int64,
    field5 LowCardinality(String),
    field6 FixedString(3),
    field7 String,
    field8 Nullable(UUID),
    event_at DateTime('UTC'),
    order_id Nullable(UUID),
    identity LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY (field1, event_at, field2, field5, id)
PARTITION BY toYYYYMM(event_at)
SETTINGS index_granularity = '8192';

INSERT INTO temp (id, field1, field2, field3, field4, field5, field6, field7, field8, event_at, order_id, identity);

SELECT *
FROM temp
ORDER BY id ASC;