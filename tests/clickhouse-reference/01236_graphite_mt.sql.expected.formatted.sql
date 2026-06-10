-- Use DateTime('UTC') to have a common rollup window
DROP TABLE IF EXISTS test_graphite;

CREATE TABLE test_graphite
(
    key UInt32,
    Path String,
    Time DateTime('UTC'),
    Value Float64,
    Version UInt32,
    col UInt64
)
ENGINE = GraphiteMergeTree('graphite_rollup')
ORDER BY key
SETTINGS index_granularity = '10';

SET joined_subquery_requires_alias = '0';

INSERT INTO test_graphite WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    -- Newer than 2 days are kept in windows of 600 seconds
    1 AS key,
    'sum_1' AS s,
    today - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(300)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    2,
    'sum_1',
    today - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(300)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    1,
    'sum_2',
    today - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(300)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    2,
    'sum_2',
    today - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(300)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    1,
    'max_1',
    today - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(300)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    2,
    'max_1',
    today - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(300)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    1,
    'max_2',
    today - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(300)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    2,
    'max_2',
    today - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(300)
UNION ALL
-- Older than 2 days use 6000 second windows
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    1 AS key,
    'sum_1' AS s,
    older_date - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(1200)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    2,
    'sum_1',
    older_date - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(1200)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    1,
    'sum_2',
    older_date - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(1200)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    2,
    'sum_2',
    older_date - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(1200)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    1,
    'max_1',
    older_date - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(1200)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    2,
    'max_1',
    older_date - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(1200)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    1,
    'max_2',
    older_date - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(1200)
UNION ALL
WITH dates AS (
    SELECT
        toStartOfDay(toDateTime(now('UTC'), 'UTC')) AS today,
        today - toIntervalDay(3) AS older_date
)

SELECT
    2,
    'max_2',
    older_date - number * 60 - 30,
    number,
    1,
    number
FROM
    dates,
    numbers(1200);

SELECT
    key,
    Path,
    Value,
    Version,
    col
FROM test_graphite FINAL
ORDER BY
    key ASC,
    Path ASC,
    Time DESC;

OPTIMIZE TABLE test_graphite FINAL;

SELECT
    key,
    Path,
    Value,
    Version,
    col
FROM test_graphite
ORDER BY
    key ASC,
    Path ASC,
    Time DESC;

DROP TABLE test_graphite;