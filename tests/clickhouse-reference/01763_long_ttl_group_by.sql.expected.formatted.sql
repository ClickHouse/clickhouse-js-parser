-- Tags: long
DROP TABLE IF EXISTS test_ttl_group_by01763;

CREATE TABLE test_ttl_group_by01763
(
    key UInt32,
    ts DateTime,
    value UInt32,
    min_value UInt32 DEFAULT value,
    max_value UInt32 DEFAULT value
)
ENGINE = MergeTree()
ORDER BY (key, toStartOfInterval(ts, toIntervalMinute(3)), ts)
PARTITION BY toYYYYMM(ts)
TTL ts + toIntervalMinute(5) GROUP BY key, toStartOfInterval(ts, toIntervalMinute(3)) SET value = sum(value), min_value = min(min_value), max_value = max(max_value), ts = min(toStartOfInterval(ts, toIntervalMinute(3)));

INSERT INTO test_ttl_group_by01763 (key, ts, value) SELECT
    number % 5 AS key,
    now() - toIntervalMinute(10) + number,
    1
FROM numbers(100000);

INSERT INTO test_ttl_group_by01763 (key, ts, value) SELECT
    number % 5 AS key,
    now() - toIntervalMinute(10) + number,
    0
FROM numbers(1000);

INSERT INTO test_ttl_group_by01763 (key, ts, value) SELECT
    number % 5 AS key,
    now() - toIntervalMinute(10) + number,
    3
FROM numbers(1000);

INSERT INTO test_ttl_group_by01763 (key, ts, value) SELECT
    number % 5 AS key,
    now() - toIntervalMonth(2) + number,
    1
FROM numbers(100000);

INSERT INTO test_ttl_group_by01763 (key, ts, value) SELECT
    number % 5 AS key,
    now() - toIntervalMonth(2) + number,
    0
FROM numbers(1000);

INSERT INTO test_ttl_group_by01763 (key, ts, value) SELECT
    number % 5 AS key,
    now() - toIntervalMonth(2) + number,
    3
FROM numbers(1000);

SELECT
    sum(value),
    min(min_value),
    max(max_value),
    uniqExact(key)
FROM test_ttl_group_by01763;

SELECT
    sum(value),
    min(min_value),
    max(max_value),
    uniqExact(key)
FROM test_ttl_group_by01763
WHERE key = 3;

SELECT
    sum(value),
    min(min_value),
    max(max_value),
    uniqExact(key)
FROM test_ttl_group_by01763
WHERE key = 3
    AND ts <= today() - toIntervalDay(30);

OPTIMIZE TABLE test_ttl_group_by01763 FINAL;

DROP TABLE test_ttl_group_by01763;