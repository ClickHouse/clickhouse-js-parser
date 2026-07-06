DROP TABLE IF EXISTS derived_metrics_local;

CREATE TABLE derived_metrics_local
(
    timestamp DateTime,
    bytes UInt64
)
ENGINE = SummingMergeTree()
ORDER BY (toStartOfHour(timestamp), timestamp)
PARTITION BY toYYYYMMDD(timestamp)
TTL toStartOfHour(timestamp) + toIntervalHour(1) GROUP BY toStartOfHour(timestamp) SET bytes = max(bytes);

SYSTEM STOP MERGES derived_metrics_local;

INSERT INTO derived_metrics_local;

INSERT INTO derived_metrics_local;

INSERT INTO derived_metrics_local;

SYSTEM START MERGES derived_metrics_local;

OPTIMIZE TABLE derived_metrics_local FINAL;

SELECT *
FROM derived_metrics_local;

DROP TABLE derived_metrics_local;

CREATE TABLE derived_metrics_local
(
    timestamp DateTime,
    timestamp_h DateTime MATERIALIZED toStartOfHour(timestamp),
    bytes UInt64
)
ENGINE = SummingMergeTree()
ORDER BY (timestamp_h, timestamp)
PARTITION BY toYYYYMMDD(timestamp)
TTL toStartOfHour(timestamp) + toIntervalHour(1) GROUP BY timestamp_h SET bytes = max(bytes), timestamp = toStartOfHour(any(timestamp));

INSERT INTO derived_metrics_local;

INSERT INTO derived_metrics_local;

INSERT INTO derived_metrics_local;

SELECT
    timestamp,
    timestamp_h,
    bytes
FROM derived_metrics_local;

CREATE TABLE derived_metrics_local
(
    timestamp DateTime,
    bytes UInt64 TTL toStartOfHour(timestamp) + toIntervalHour(1)
)
ENGINE = MergeTree()
ORDER BY (toStartOfHour(timestamp), timestamp)
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO derived_metrics_local;

SELECT sum(bytes)
FROM derived_metrics_local;

CREATE TABLE derived_metrics_local
(
    timestamp DateTime,
    bytes UInt64
)
ENGINE = MergeTree()
ORDER BY (toStartOfHour(timestamp), timestamp)
PARTITION BY toYYYYMMDD(timestamp)
TTL toStartOfHour(timestamp) + toIntervalHour(1)
SETTINGS min_bytes_for_wide_part = '0';

SELECT count()
FROM derived_metrics_local;