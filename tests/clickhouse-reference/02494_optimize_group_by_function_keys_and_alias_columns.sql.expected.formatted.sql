CREATE TABLE t
(
    timestamp DateTime,
    day ALIAS toYYYYMMDD(timestamp)
)
ENGINE = MergeTree()
ORDER BY timestamp;

INSERT INTO t (timestamp);

SELECT
    day,
    timestamp
FROM remote('127.0.0.{1,2}', currentDatabase(), t)
GROUP BY
    day,
    timestamp
ORDER BY timestamp ASC;