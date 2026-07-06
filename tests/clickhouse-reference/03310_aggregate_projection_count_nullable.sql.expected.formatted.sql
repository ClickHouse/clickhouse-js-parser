DROP TABLE IF EXISTS log;

CREATE TABLE log
(
    collectorReceiptTime DateTime,
    eventId String,
    ruleId Nullable(String),
    PROJECTION ailog_rule_count (SELECT collectorReceiptTime, ruleId, count(ruleId) GROUP BY collectorReceiptTime, ruleId)
)
ENGINE = MergeTree()
ORDER BY (collectorReceiptTime, eventId)
PARTITION BY toYYYYMMDD(collectorReceiptTime);

INSERT INTO log;

INSERT INTO log;

INSERT INTO log;

INSERT INTO log;

INSERT INTO log;

INSERT INTO log;

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SELECT
    formatDateTime(toStartOfInterval(collectorReceiptTime, toIntervalHour(1)), '%Y-%m-%d %H') AS time,
    COUNT() AS count
FROM log
WHERE collectorReceiptTime >= '2025-01-01 00:00:00'
    AND collectorReceiptTime <= '2025-01-01 23:59:59'
GROUP BY time
ORDER BY time DESC;

-- Another similar case to verify that COUNT(NOT NULL) should be able to use aggregate projection.
DROP TABLE log;

CREATE TABLE log
(
    collectorReceiptTime DateTime,
    eventId String,
    ruleId String,
    PROJECTION ailog_rule_count (SELECT collectorReceiptTime, ruleId, count(ruleId) GROUP BY collectorReceiptTime, ruleId)
)
ENGINE = MergeTree()
ORDER BY (collectorReceiptTime, eventId)
PARTITION BY toYYYYMMDD(collectorReceiptTime);

INSERT INTO log;

INSERT INTO log;

INSERT INTO log;

INSERT INTO log;

INSERT INTO log;

INSERT INTO log;

SELECT
    formatDateTime(toStartOfInterval(collectorReceiptTime, toIntervalHour(1)), '%Y-%m-%d %H') AS time,
    COUNT() AS count
FROM log
WHERE collectorReceiptTime >= '2025-01-01 00:00:00'
    AND collectorReceiptTime <= '2025-01-01 23:59:59'
GROUP BY time
ORDER BY time DESC
SETTINGS force_optimize_projection = '1';