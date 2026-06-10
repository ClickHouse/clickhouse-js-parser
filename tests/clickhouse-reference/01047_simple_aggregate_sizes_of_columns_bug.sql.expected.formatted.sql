DROP TABLE IF EXISTS column_size_bug;

CREATE TABLE column_size_bug
(
    date_time DateTime,
    value SimpleAggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
ORDER BY date_time
PARTITION BY toStartOfInterval(date_time, toIntervalDay(1))
SETTINGS remove_empty_parts = '0';

INSERT INTO column_size_bug;

ALTER TABLE column_size_bug DELETE WHERE value = 1;

-- wait for DELETE
SELECT sleep(1);

OPTIMIZE TABLE column_size_bug;

DROP TABLE column_size_bug;