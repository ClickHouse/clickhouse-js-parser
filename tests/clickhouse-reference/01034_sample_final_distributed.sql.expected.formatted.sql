-- Tags: distributed
SET enable_parallel_replicas = '1';

SET parallel_replicas_mode = 'sampling_key';

SET max_parallel_replicas = '3';

SET parallel_replicas_for_non_replicated_merge_tree = '1';

DROP TABLE IF EXISTS sample_final;

CREATE TABLE sample_final
(
    CounterID UInt32,
    EventDate Date,
    EventTime DateTime,
    UserID UInt64,
    Sign Int8
)
ENGINE = CollapsingMergeTree(Sign)
ORDER BY (CounterID, EventDate, intHash32(UserID), EventTime)
SAMPLE BY intHash32(UserID)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO sample_final SELECT
    number / (8192 * 4),
    toDate('2019-01-01'),
    toDateTime('2019-01-01 00:00:01') + number,
    number / (8192 * 2),
    number % 3 = 1 ? -1 : 1
FROM numbers(1000000);

SELECT count()
FROM sample_final;

SELECT count()
FROM sample_final FINAL;

SELECT count()
FROM sample_final SAMPLE 1/2;

SELECT count()
FROM sample_final FINAL SAMPLE 1/2;

SET max_parallel_replicas = '2';

SELECT count()
FROM remote('127.0.0.{2|3}', currentDatabase(), sample_final) FINAL;