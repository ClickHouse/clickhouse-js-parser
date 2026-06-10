-- add_minmax_index_for_numeric_columns=0: Implicit indices will filter before projections
DROP TABLE IF EXISTS projection_test;

CREATE TABLE projection_test
(
    `sum(block_count)` UInt64,
    domain_alias UInt64 ALIAS length(domain),
    datetime DateTime,
    domain LowCardinality(String),
    x_id String,
    y_id String,
    block_count Int64,
    retry_count Int64,
    duration Int64,
    kbytes Int64,
    buffer_time Int64,
    first_time Int64,
    total_bytes Nullable(UInt64),
    valid_bytes Nullable(UInt64),
    completed_bytes Nullable(UInt64),
    fixed_bytes Nullable(UInt64),
    force_bytes Nullable(UInt64),
    PROJECTION p (SELECT toStartOfMinute(datetime) AS dt_m, countIf(first_time = 0) / count(), avg(kbytes * 8 / duration), count(), sum(block_count) / sum(duration), avg(block_count / duration), sum(buffer_time) / sum(duration), avg(buffer_time / duration), sum(valid_bytes) / sum(total_bytes), sum(completed_bytes) / sum(total_bytes), sum(fixed_bytes) / sum(total_bytes), sum(force_bytes) / sum(total_bytes), sum(valid_bytes) / sum(total_bytes), sum(retry_count) / sum(duration), avg(retry_count / duration), countIf(block_count > 0) / count(), countIf(first_time = 0) / count(), uniqHLL12(x_id), uniqHLL12(y_id) GROUP BY dt_m, domain)
)
ENGINE = MergeTree()
ORDER BY toStartOfTenMinutes(datetime)
PARTITION BY toDate(datetime)
SETTINGS index_granularity_bytes = '10000000', add_minmax_index_for_numeric_columns = '0';

INSERT INTO projection_test WITH rowNumberInAllBlocks() AS id

SELECT
    1,
    toDateTime('2020-10-24 00:00:00') + id / 20,
    toString(id % 100),
    *
FROM generateRandom('x_id String, y_id String, block_count Int64, retry_count Int64, duration Int64, kbytes Int64, buffer_time Int64, first_time Int64, total_bytes Nullable(UInt64), valid_bytes Nullable(UInt64), completed_bytes Nullable(UInt64), fixed_bytes Nullable(UInt64), force_bytes Nullable(UInt64)', 10, 10, 1)
LIMIT 1000
SETTINGS max_threads = '1';

SET optimize_use_projections = '1', force_optimize_projection = '1';

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SELECT *
FROM projection_test; -- { serverError PROJECTION_NOT_USED }

SELECT
    toStartOfMinute(datetime) AS dt_m,
    countIf(first_time = 0)
FROM
    projection_test
INNER JOIN (
        SELECT 1
    ) AS x
    ON 1
WHERE domain = '1'
GROUP BY dt_m
ORDER BY dt_m ASC; -- { serverError PROJECTION_NOT_USED }

SELECT
    toStartOfMinute(datetime) AS dt_m,
    countIf(first_time = 0) / count(),
    avg(kbytes * 8 / duration)
FROM projection_test
WHERE domain = '1'
GROUP BY dt_m
ORDER BY dt_m ASC;

-- prewhere with alias
SELECT
    toStartOfMinute(datetime) AS dt_m,
    countIf(first_time = 0) / count(),
    avg(kbytes * 8 / duration)
FROM projection_test
PREWHERE domain_alias = 3
WHERE domain = '1'
GROUP BY dt_m
ORDER BY dt_m ASC;

DROP ROW POLICY IF EXISTS filter ON projection_test;

CREATE ROW POLICY filter ON projection_test USING domain = 'non_existing_domain' TO ALL;

-- prewhere with alias with row policy (non existing)
SELECT
    toStartOfMinute(datetime) AS dt_m,
    countIf(first_time = 0) / count(),
    avg(kbytes * 8 / duration)
FROM projection_test
PREWHERE domain_alias = 1
WHERE domain = '1'
GROUP BY dt_m
ORDER BY dt_m ASC;

DROP ROW POLICY filter ON projection_test;

-- TODO There is a bug in row policy filter (not related to projections, crash in master)
-- drop row policy if exists filter on projection_test;
-- create row policy filter on projection_test using (domain != '1') to all;
-- prewhere with alias with row policy (existing)
-- select toStartOfMinute(datetime) dt_m, countIf(first_time = 0) / count(), avg((kbytes * 8) / duration) from projection_test prewhere domain_alias = 1 where domain = '1' group by dt_m order by dt_m;
-- drop row policy filter on projection_test;
SELECT
    toStartOfMinute(datetime) AS dt_m,
    count(),
    sum(block_count) / sum(duration),
    avg(block_count / duration)
FROM projection_test
GROUP BY dt_m
ORDER BY dt_m ASC;

-- TODO figure out how to deal with conflict column names
-- select toStartOfMinute(datetime) dt_m, count(), sum(block_count) / sum(duration), avg(block_count / duration) from projection_test where `sum(block_count)` = 1 group by dt_m order by dt_m;
SELECT
    toStartOfMinute(datetime) AS dt_m,
    sum(buffer_time) / sum(duration),
    avg(buffer_time / duration),
    sum(valid_bytes) / sum(total_bytes),
    sum(completed_bytes) / sum(total_bytes),
    sum(fixed_bytes) / sum(total_bytes),
    sum(force_bytes) / sum(total_bytes),
    sum(valid_bytes) / sum(total_bytes)
FROM projection_test
WHERE domain IN ('12', '14')
GROUP BY dt_m
ORDER BY dt_m ASC;

SELECT
    toStartOfMinute(datetime) AS dt_m,
    domain,
    sum(retry_count) / sum(duration),
    avg(retry_count / duration),
    countIf(block_count > 0) / count(),
    countIf(first_time = 0) / count()
FROM projection_test
GROUP BY
    dt_m,
    domain
HAVING domain = '19'
ORDER BY
    dt_m ASC,
    domain ASC;

SELECT
    toStartOfHour(toStartOfMinute(datetime)) AS dt_h,
    uniqHLL12(x_id),
    uniqHLL12(y_id)
FROM projection_test
GROUP BY dt_h
ORDER BY dt_h ASC;

-- found by fuzzer
SET enable_positional_arguments = '0', force_optimize_projection = '0';

SELECT
    2,
    -1
FROM projection_test
PREWHERE domain_alias = 1.
WHERE domain = NULL
GROUP BY -9223372036854775808
ORDER BY
    countIf(first_time = 0) / count(-2147483649) DESC NULLS LAST,
    1048576 DESC NULLS LAST;

DROP TABLE IF EXISTS projection_without_key;

CREATE TABLE projection_without_key
(
    key UInt32,
    PROJECTION x (SELECT max(key))
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO projection_without_key SELECT number
FROM numbers(1000);

SET force_optimize_projection = '1', optimize_use_projections = '1';

SELECT max(key)
FROM projection_without_key;

DROP TABLE projection_without_key;