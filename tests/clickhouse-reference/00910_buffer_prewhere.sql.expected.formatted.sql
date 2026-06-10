CREATE TABLE mt
(
    uid UInt64,
    ts DateTime,
    val Float64
)
ENGINE = MergeTree()
ORDER BY (uid, ts)
PARTITION BY toDate(ts);

CREATE TABLE buf AS mt
ENGINE = Buffer(CLICKHOUSE_DATABASE, mt, 2, 10, 60, 10000, 100000, 1000000, 10000000);

INSERT INTO buf;

SELECT count()
FROM buf
PREWHERE ts > toDateTime('2019-03-01 12:00:00')
    AND ts < toDateTime('2019-03-02 12:00:00');