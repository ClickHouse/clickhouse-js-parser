SET session_timezone = 'Etc/UTC';

DROP TABLE IF EXISTS tt;

CREATE TABLE tt
(
    id Int64,
    ts DateTime
)
ENGINE = MergeTree()
ORDER BY dateTrunc('hour', ts)
SETTINGS index_granularity = '8192';

INSERT INTO tt;

SELECT id
FROM tt
PREWHERE ts >= toDateTime(1731506400)
    AND ts <= toDateTime(1731594420);

EXPLAIN indexes = '1', description = '0'
SELECT id
FROM tt
PREWHERE ts >= toDateTime(1731506400)
    AND ts <= toDateTime(1731594420);

DROP TABLE tt;