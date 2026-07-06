-- { echo ON }
DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    dt DateTime,
    i Int32 DEFAULT 42 TTL dt + toIntervalDay(1),
    INDEX idx i TYPE set(100) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY dt
PARTITION BY indexHint(dt)
SETTINGS index_granularity = '8192', min_bytes_for_wide_part = '0';

SYSTEM STOP MERGES x;

INSERT INTO x;

SELECT i
FROM x
WHERE i = 1;

SYSTEM START MERGES x;

OPTIMIZE TABLE x FINAL;

SELECT i
FROM x
WHERE i = 42;

DROP TABLE x;

CREATE TABLE x
(
    dt DateTime,
    i Int32 DEFAULT 42 TTL dt + toIntervalDay(1)
)
ENGINE = ReplacingMergeTree(i)
ORDER BY dt
SETTINGS index_granularity = '8192', min_bytes_for_wide_part = '0';

CREATE TABLE x
(
    dt DateTime,
    i Int32 DEFAULT 42 TTL dt + toIntervalDay(1)
)
ENGINE = MergeTree()
ORDER BY dt
SETTINGS index_granularity = '8192', min_bytes_for_wide_part = '0';

INSERT INTO x;

OPTIMIZE TABLE x FINAL DEDUPLICATE BY dt, i;

SELECT i
FROM x;