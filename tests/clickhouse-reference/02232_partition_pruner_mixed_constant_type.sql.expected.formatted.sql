DROP TABLE IF EXISTS broken;

CREATE TABLE broken
(
    time UInt64
)
ENGINE = MergeTree()
ORDER BY time
PARTITION BY toYYYYMMDD(toDate(time / 1000));

INSERT INTO broken (time);

SELECT *
FROM broken
WHERE time > -1;

DROP TABLE broken;