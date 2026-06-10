-- Tags: no-parallel
CREATE TABLE t
(
    timestamp DateTime,
    id String,
    value UInt16
)
ENGINE = MergeTree()
ORDER BY (id, toStartOfDay(timestamp))
TTL timestamp + toIntervalDay(1) GROUP BY id, toStartOfDay(timestamp) SET timestamp = max(timestamp) + toIntervalYear(100), id = argMax(id, timestamp), value = max(value);

SYSTEM STOP MERGES t;

INSERT INTO t;

INSERT INTO t;

-- Inserts the maximum value, but with an older timestmap. The value should be taken in the aggregation.
INSERT INTO t;

INSERT INTO t;

-- Inserts the latest timestamp, which should be the one taken in the aggregation.
INSERT INTO t;

SYSTEM START MERGES t;

OPTIMIZE TABLE t FINAL;

SELECT '-- Intersecting columns in GROUP BY and SET';

SELECT *
FROM t
ORDER BY `ALL` ASC;

REPLACE TABLE t
(
    timestamp DateTime,
    id String,
    value String
)
ENGINE = MergeTree()
ORDER BY (id, toStartOfDay(timestamp))
TTL timestamp + toIntervalDay(1) GROUP BY id, toStartOfDay(timestamp) SET timestamp = max(timestamp) + toIntervalYear(100), id = max(value);

INSERT INTO t;

INSERT INTO t;

INSERT INTO t;