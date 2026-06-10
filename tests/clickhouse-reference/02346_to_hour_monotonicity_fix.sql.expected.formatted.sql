DROP TABLE IF EXISTS test_tz_hour;

CREATE TABLE test_tz_hour
(
    t DateTime,
    x String
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY toYYYYMMDD(t);

INSERT INTO test_tz_hour SELECT
    toDateTime('2021-06-01 00:00:00', 'UTC') + number * 600,
    'x'
FROM numbers(1000.);

SELECT
    toHour(toTimeZone(t, 'UTC')) AS toHour_UTC,
    toHour(toTimeZone(t, 'Asia/Jerusalem')) AS toHour_Israel,
    count()
FROM test_tz_hour
WHERE toHour_Israel = 8
GROUP BY
    toHour_UTC,
    toHour_Israel;

DROP TABLE test_tz_hour;