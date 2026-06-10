-- Tags: distributed
SET enable_parallel_replicas = '0';

DROP TABLE IF EXISTS test5346;

CREATE TABLE test5346
(
    Id String,
    Timestamp DateTime,
    updated DateTime
)
ENGINE = ReplacingMergeTree(updated)
ORDER BY (Timestamp, Id)
PARTITION BY tuple();

INSERT INTO test5346;

SELECT
    Id,
    Timestamp
FROM remote('localhost,127.0.0.1,127.0.0.2', currentDatabase(), 'test5346') FINAL
ORDER BY Timestamp ASC;

SELECT
    Id,
    Timestamp
FROM remote('localhost,127.0.0.1,127.0.0.2', currentDatabase(), 'test5346') FINAL
ORDER BY identity(Timestamp) ASC;

DROP TABLE test5346;