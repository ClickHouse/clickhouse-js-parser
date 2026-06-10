DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    id UInt64,
    ts DateTime
)
ENGINE = MergeTree()
ORDER BY (id, ts)
SETTINGS index_granularity = '2';

INSERT INTO t;

SELECT count(abs(toUnixTimestamp(ts, 'UTC') - toUnixTimestamp('2023-05-04 22:17:23', 'UTC')) AS error)
FROM t
WHERE error < 3600;