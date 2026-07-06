-- Tags: no-fasttest
-- To make fasttest fast (this test sleeps a lot)
-- We use sleep(5) just to wait a little bit to wait some Buffer flushes, if
-- there are excessive flushes 5 seconds should be enough to catch them.
SET function_sleep_max_microseconds_per_block = 5000000000.;

DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    key Int
)
ENGINE = Null();

DROP TABLE IF EXISTS empty_buffer;

CREATE TABLE empty_buffer
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data, 2, 2, 4, 100000, 1000000, 10000000000., 10000000000., 3);

SELECT sleep(5)
FORMAT Null;

OPTIMIZE TABLE empty_buffer;

DROP TABLE empty_buffer;

DROP TABLE IF EXISTS empty_buffer_zero_time;

CREATE TABLE empty_buffer_zero_time
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data, 2, 0, 0, 100000, 1000000, 10000000000., 10000000000., 0);

SELECT sleep(1)
FORMAT Null;

OPTIMIZE TABLE empty_buffer_zero_time;

DROP TABLE empty_buffer_zero_time;

DROP TABLE IF EXISTS buffer_flush_by_min;

CREATE TABLE buffer_flush_by_min
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data, 2, 2, 4, 100000, 1000000, 0, 10000000000., 3);

INSERT INTO buffer_flush_by_min SELECT *
FROM numbers(100000 + 1);

DROP TABLE buffer_flush_by_min;

DROP TABLE IF EXISTS buffer_flush_by_max;

CREATE TABLE buffer_flush_by_max
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data, 2, 2, 4, 100000, 1000000, 0, 10000000000.);

INSERT INTO buffer_flush_by_max SELECT *
FROM numbers(1);

DROP TABLE buffer_flush_by_max;

DROP TABLE IF EXISTS buffer_flush_by_flush_time;

CREATE TABLE buffer_flush_by_flush_time
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data, 2, 2, 4, 100000, 1000000, 10000000000., 10000000000., 3);

INSERT INTO buffer_flush_by_flush_time;

DROP TABLE buffer_flush_by_flush_time;

SYSTEM FLUSH LOGS text_log;

-- to avoid flakiness we only check that number of logs < 20, instead of some strict values
SELECT
    extractAll(logger_name, 'StorageBuffer \\([^.]+\\.([^)]+)\\)')[1] AS table_name,
    max2(count(), 20)
FROM `system`.text_log
WHERE logger_name LIKE format('%StorageBuffer ({}.%', currentDatabase())
GROUP BY 1
ORDER BY 1 ASC;