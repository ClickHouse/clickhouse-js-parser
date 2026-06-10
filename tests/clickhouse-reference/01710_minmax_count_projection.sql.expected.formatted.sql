DROP TABLE IF EXISTS d;

CREATE TABLE d
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY i % 2
SETTINGS index_granularity = '1';

INSERT INTO d SELECT
    number,
    number
FROM numbers(10000);

SET max_rows_to_read = '2', optimize_use_projections = '1', optimize_use_implicit_projections = '1', optimize_use_projection_filtering = '1';

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SELECT
    min(i),
    max(i),
    count()
FROM d;

SELECT
    min(i),
    max(i),
    count()
FROM d
GROUP BY _partition_id
ORDER BY _partition_id ASC;

SELECT
    min(i),
    max(i),
    count()
FROM d
WHERE (_partition_value).1 = 0
GROUP BY _partition_id
ORDER BY _partition_id ASC;

SELECT
    min(i),
    max(i),
    count()
FROM d
WHERE moduloLegacy(i, 2) = 0
GROUP BY _partition_id
ORDER BY _partition_id ASC;

SELECT
    min(i),
    max(i),
    count()
FROM d
WHERE (_partition_value).1 = 10
GROUP BY _partition_id
ORDER BY _partition_id ASC;

-- fuzz crash
SELECT min(i)
FROM d
WHERE 1 = (_partition_value).1;

-- fuzz crash https://github.com/ClickHouse/ClickHouse/issues/37151
SELECT
    min(i),
    max(i),
    count()
FROM d
WHERE (_partition_value).1 = 0
GROUP BY
    ignore(bitTest(ignore(NULL), 0), NULL, (_partition_value).1 = 7, '10.25', bitTest(NULL, 0), NULL, ignore(ignore(-2147483647, NULL)), 1024),
    _partition_id
ORDER BY _partition_id ASC NULLS FIRST;

DROP TABLE d;

DROP TABLE IF EXISTS has_final_mark;

DROP TABLE IF EXISTS mixed_final_mark;

CREATE TABLE has_final_mark
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY i % 2
SETTINGS index_granularity = '10', write_final_mark = '1';

CREATE TABLE mixed_final_mark
(
    i int,
    j int
)
ENGINE = MergeTree()
ORDER BY j
PARTITION BY i % 2
SETTINGS index_granularity = '10';

SET max_rows_to_read = '100000';

INSERT INTO has_final_mark SELECT
    number,
    number
FROM numbers(10000);

ALTER TABLE mixed_final_mark ATTACH PARTITION 1 FROM has_final_mark;

SET max_rows_to_read = '2';

SELECT min(j)
FROM has_final_mark;

SELECT min(j)
FROM mixed_final_mark;

SELECT
    min(j),
    max(j)
FROM has_final_mark;

SET max_rows_to_read = '5001'; -- one normal part 5000 + one minmax_count_projection part 1

SELECT
    min(j),
    max(j)
FROM mixed_final_mark;

-- The first primary expr is the same of some partition column
DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    server_date Date,
    something String
)
ENGINE = MergeTree()
ORDER BY (server_date, something)
PARTITION BY (toYYYYMM(server_date), server_date);

INSERT INTO t;

SELECT count()
FROM t;

DROP TABLE t;

CREATE TABLE d
(
    dt DateTime,
    j int
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY (toDate(dt), ceiling(j), toDate(dt), CEILING(j));

INSERT INTO d;

SELECT
    min(dt),
    max(dt),
    count()
FROM d
WHERE toDate(dt) >= '2021-10-25';

-- fuzz crash
SELECT
    min(dt),
    max(dt),
    count(toDate(dt) >= '2021-10-25')
FROM d
WHERE toDate(dt) >= '2021-10-25';

SELECT count()
FROM d
GROUP BY toDate(dt);

-- fuzz crash
SELECT
    min(dt),
    count(ignore(ignore(ignore(tupleElement(_partition_value, 'xxxx', NULL) = NULL), NULL, NULL, NULL), 0, '10485.76', NULL)),
    max(dt),
    count(toDate(dt) >= '2021-10-25')
FROM d
WHERE toDate(dt) >= '2021-10-25';

-- fuzz crash
SELECT
    pointInEllipses(min(j), NULL),
    max(dt),
    count('0.0000000007')
FROM d
WHERE toDate(dt) >= '2021-10-25';

SELECT min(j)
FROM d
PREWHERE ceil(j) <= 0;

SELECT min(dt)
FROM d
PREWHERE ((0.9998999834060669
    AND 1023)
    AND 255) <= ceil(j);

SELECT count('')
    AND NULL
FROM d
PREWHERE ceil(j) <= NULL;

-- count variant optimization
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    id Int64,
    d Int64
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test SELECT
    number,
    number
FROM numbers(1000.);

SELECT count(if(d = 4, d, 1))
FROM test
SETTINGS force_optimize_projection = '1';

SELECT count(d / 3)
FROM test
SETTINGS force_optimize_projection = '1';

SELECT count(if(d = 4, NULL, 1))
FROM test
SETTINGS force_optimize_projection = '1'; -- { serverError PROJECTION_NOT_USED }

DROP TABLE test;