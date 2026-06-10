CREATE TABLE rmt
(
    n int,
    ts DateTime64(8, 'UTC')
)
ENGINE = ReplicatedMergeTree('/test/02487/{database}/rmt', '1')
ORDER BY n;

ALTER TABLE rmt ADD INDEX idx1 date(ts) TYPE MinMax() GRANULARITY 1;

CREATE INDEX idx2 ON rmt (date(ts)) TYPE MinMax GRANULARITY 1;

SYSTEM RESTART REPLICA rmt;

CREATE TABLE rmt2
(
    n int,
    ts DateTime64(8, 'UTC'),
    INDEX idx1 date(ts) TYPE MinMax() GRANULARITY 1,
    INDEX idx2 date(ts) TYPE MinMax() GRANULARITY 1
)
ENGINE = ReplicatedMergeTree('/test/02487/{database}/rmt', '2')
ORDER BY n;