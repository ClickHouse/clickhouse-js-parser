DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    stamp DateTime('UTC')
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toDate(stamp) AS
SELECT toDateTime('2020-01-01', 'UTC') + number * 60
FROM numbers(1000.);

SELECT count() AS result
FROM test
WHERE toHour(stamp, 'America/Montreal') = 7;

DROP TABLE test;

CREATE TABLE test
(
    stamp Nullable(DateTime('UTC'))
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toDate(stamp)
SETTINGS allow_nullable_key = '1' AS
SELECT toDateTime('2020-01-01', 'UTC') + number * 60
FROM numbers(1000.);