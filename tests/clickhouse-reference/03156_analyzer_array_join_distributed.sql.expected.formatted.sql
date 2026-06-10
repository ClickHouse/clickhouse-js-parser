CREATE TABLE arrays_test
(
    s String,
    arr Array(UInt8)
)
ENGINE = MergeTree()
ORDER BY s;

INSERT INTO arrays_test;

SELECT
    s,
    arr,
    a
FROM
    remote('127.0.0.2', currentDatabase(), arrays_test)
ARRAY JOIN arr AS a
WHERE a < 3
ORDER BY a ASC;

SELECT
    s,
    arr,
    a
FROM
    remote('127.0.0.{1,2}', currentDatabase(), arrays_test)
ARRAY JOIN arr AS a
WHERE a < 3
ORDER BY a ASC;

SELECT
    s,
    arr
FROM
    remote('127.0.0.2', currentDatabase(), arrays_test)
ARRAY JOIN arr
WHERE arr < 3
ORDER BY arr ASC;

SELECT
    s,
    arr
FROM
    remote('127.0.0.{1,2}', currentDatabase(), arrays_test)
ARRAY JOIN arr
WHERE arr < 3
ORDER BY arr ASC;

CREATE TABLE hourly
(
    hour datetime,
    `metric.names` Array(String),
    `metric.values` Array(Int64)
)
ENGINE = Memory() AS
SELECT
    '2020-01-01',
    ['a', 'b'],
    [1, 2];

SELECT
    toDate(hour) AS day,
    `metric.names`,
    sum(`metric.values`)
FROM
    remote('127.0.0.{1,2}', currentDatabase(), hourly)
ARRAY JOIN metric
GROUP BY
    day,
    metric.names
ORDER BY metric.names ASC;