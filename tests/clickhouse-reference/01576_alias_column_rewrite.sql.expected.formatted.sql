DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    timestamp DateTime,
    value UInt64,
    day Date ALIAS toDate(timestamp),
    day1 Date ALIAS day + 1,
    day2 Date ALIAS day1 + 1,
    time DateTime ALIAS timestamp
)
ENGINE = MergeTree()
ORDER BY timestamp
PARTITION BY toYYYYMMDD(timestamp)
SETTINGS index_granularity = '1';

INSERT INTO test_table (timestamp, value) SELECT
    toDateTime('2020-01-01 12:00:00'),
    1
FROM numbers(10);

INSERT INTO test_table (timestamp, value) SELECT
    toDateTime('2020-01-02 12:00:00'),
    1
FROM numbers(10);

INSERT INTO test_table (timestamp, value) SELECT
    toDateTime('2020-01-03 12:00:00'),
    1
FROM numbers(10);

SET optimize_respect_aliases = '1';

SELECT COUNT() = 10
FROM test_table
WHERE day = '2020-01-01'
SETTINGS max_rows_to_read = '10';

SELECT t = '2020-01-03'
FROM (
        SELECT day AS t
        FROM test_table
        WHERE t = '2020-01-03'
        GROUP BY t
        SETTINGS max_rows_to_read = '10'
    );

SELECT COUNT() = 10
FROM test_table
WHERE day = '2020-01-01'
UNION ALL
SELECT 1
FROM numbers(1)
SETTINGS max_rows_to_read = '11';

SELECT COUNT() = 0
FROM (
        SELECT
            toDate('2019-01-01') AS day,
            day AS t
        FROM test_table
        PREWHERE t = '2020-01-03'
        WHERE t = '2020-01-03'
        GROUP BY t
    );

SELECT day = '2020-01-03'
FROM
    (
        SELECT toDate('2020-01-03') AS day
        FROM numbers(1)
    ) AS a
INNER JOIN (
        SELECT day
        FROM test_table
        WHERE day = '2020-01-03'
        GROUP BY day
    ) AS b
    ON a.day = b.day
SETTINGS max_rows_to_read = '11';

SELECT day = '2020-01-01'
FROM
    (
        SELECT day
        FROM test_table
        WHERE day = '2020-01-01'
        GROUP BY day
    ) AS a
INNER JOIN (
        SELECT toDate('2020-01-01') AS day
        FROM numbers(1)
    ) AS b
    ON a.day = b.day
SETTINGS max_rows_to_read = '11';

SELECT COUNT() = 10
FROM test_table
WHERE day1 = '2020-01-02'
SETTINGS max_rows_to_read = '10';

SELECT t = '2020-01-03'
FROM (
        SELECT day1 AS t
        FROM test_table
        WHERE t = '2020-01-03'
        GROUP BY t
        SETTINGS max_rows_to_read = '10'
    );

SELECT t = '2020-01-03'
FROM (
        SELECT day2 AS t
        FROM test_table
        WHERE t = '2020-01-03'
        GROUP BY t
        SETTINGS max_rows_to_read = '10'
    );

SELECT COUNT() = 10
FROM test_table
WHERE day1 = '2020-01-03'
UNION ALL
SELECT 1
FROM numbers(1)
SETTINGS max_rows_to_read = '11';

SELECT COUNT() = 0
FROM (
        SELECT
            toDate('2019-01-01') AS day1,
            day1 AS t
        FROM test_table
        PREWHERE t = '2020-01-03'
        WHERE t = '2020-01-03'
        GROUP BY t
    );

SELECT day1 = '2020-01-04'
FROM test_table
PREWHERE day1 = '2020-01-04'
WHERE day1 = '2020-01-04'
GROUP BY day1
SETTINGS max_rows_to_read = '10';

ALTER TABLE test_table ADD COLUMN `array` Array(UInt8) DEFAULT [1, 2, 3];

ALTER TABLE test_table ADD COLUMN `struct.key` Array(UInt8) DEFAULT [2, 4, 6], ADD COLUMN `struct.value` Array(UInt8) ALIAS `array`;

SET max_rows_to_read = '10';

SELECT count() = 10
FROM test_table
WHERE day = '2020-01-01';

SELECT
    sum(struct.key) = 30,
    sum(struct.value) = 30
FROM (
        SELECT
            struct.key,
            struct.value
        FROM
            test_table
        ARRAY JOIN struct
        WHERE day = '2020-01-01'
    );

-- lambda parameters in filter should not be rewrite
SELECT count() = 10
FROM test_table
WHERE arrayMap((day -> day + 1), [1, 2, 3])[1] = 2
    AND day = '2020-01-03';

SET max_rows_to_read = '0';

EXPLAIN description = '0'
SELECT day AS s
FROM test_table
ORDER BY s ASC
LIMIT 1
SETTINGS optimize_read_in_order = '0';

EXPLAIN description = '0'
SELECT day AS s
FROM test_table
ORDER BY s ASC
LIMIT 1
SETTINGS optimize_read_in_order = '1';

EXPLAIN description = '0'
SELECT toDate(timestamp) AS s
FROM test_table
ORDER BY toDate(timestamp) ASC
LIMIT 1
SETTINGS optimize_read_in_order = '1';

EXPLAIN description = '0'
SELECT
    day,
    count() AS s
FROM test_table
GROUP BY day
SETTINGS optimize_aggregation_in_order = '0';

EXPLAIN description = '0'
SELECT
    day,
    count() AS s
FROM test_table
GROUP BY day
SETTINGS optimize_aggregation_in_order = '1';

EXPLAIN description = '0'
SELECT
    toDate(timestamp),
    count() AS s
FROM test_table
GROUP BY toDate(timestamp)
SETTINGS optimize_aggregation_in_order = '1';

DROP TABLE test_table;

DROP TABLE IF EXISTS test_index;

CREATE TABLE test_index
(
    key_string String,
    key_uint32 ALIAS toUInt32(key_string),
    INDEX idx toUInt32(key_string) TYPE set(0) GRANULARITY 1
)
ENGINE = MergeTree()
PRIMARY KEY tuple()
ORDER BY key_string
PARTITION BY tuple()
SETTINGS index_granularity = '1';

INSERT INTO test_index SELECT *
FROM numbers(10);

SET max_rows_to_read = '1';

SELECT COUNT() = 1
FROM test_index
WHERE key_uint32 = 1;

SELECT COUNT() = 1
FROM test_index
WHERE toUInt32(key_string) = 1;

-- check alias column can be used to match projections
DROP TABLE IF EXISTS pd;

DROP TABLE IF EXISTS pl;

CREATE TABLE pd
(
    dt DateTime,
    i int,
    dt_m DateTime ALIAS toStartOfMinute(dt)
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 'pl');

CREATE TABLE pl
(
    dt DateTime,
    i int,
    PROJECTION p (SELECT sum(i) GROUP BY toStartOfMinute(dt))
)
ENGINE = MergeTree()
ORDER BY dt;

INSERT INTO pl;

SET max_rows_to_read = '2';

SELECT sum(i)
FROM pd
GROUP BY dt_m
SETTINGS
    optimize_use_projections = '1',
    force_optimize_projection = '1';

DROP TABLE pd;

DROP TABLE pl;

DROP TABLE IF EXISTS t;

CREATE TEMPORARY TABLE t
(
    x UInt64,
    y ALIAS x
);

INSERT INTO t;

SELECT
    sum(x),
    sum(y)
FROM t;

DROP TABLE t;