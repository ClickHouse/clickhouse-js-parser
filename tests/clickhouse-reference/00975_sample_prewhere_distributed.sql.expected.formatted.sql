-- Tags: distributed
CREATE TABLE IF NOT EXISTS sample_prewhere
(
    date Date,
    id Int32,
    time Int64
)
ENGINE = MergeTree()
ORDER BY (id, time, intHash64(time))
PARTITION BY date
SAMPLE BY intHash64(time);

INSERT INTO sample_prewhere;

INSERT INTO sample_prewhere;

INSERT INTO sample_prewhere;

SELECT id
FROM remote('127.0.0.{1,3}', currentDatabase(), sample_prewhere) SAMPLE 1
WHERE toDateTime(time) = '2019-07-20 00:00:00';

DROP TABLE sample_prewhere;