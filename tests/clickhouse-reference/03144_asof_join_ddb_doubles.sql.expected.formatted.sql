SET join_algorithm = 'full_sorting_merge';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS events0;

CREATE TABLE events0
(
    begin Float64,
    value Int32
)
ENGINE = MergeTree()
ORDER BY begin;

INSERT INTO events0;

SELECT
    p.ts,
    e.value
FROM
    (
        SELECT number::Float64 AS ts
        FROM numbers(10)
    ) AS p
ASOF INNER JOIN events0 AS e
    ON p.ts >= e.begin
ORDER BY p.ts ASC;

SELECT
    p.ts,
    e.value
FROM
    (
        SELECT number::Float64 AS ts
        FROM numbers(10)
    ) AS p
ASOF LEFT JOIN events0 AS e
    ON p.ts >= e.begin
ORDER BY p.ts ASC;

-- SETTINGS join_use_nulls = 1
DROP TABLE IF EXISTS events;

DROP TABLE IF EXISTS probes;

CREATE TABLE events
(
    key Int32,
    begin Float64,
    value Int32
)
ENGINE = MergeTree()
ORDER BY (key, begin);

INSERT INTO events;

CREATE TABLE probes
(
    key Int32,
    ts Float64
)
ENGINE = MergeTree()
ORDER BY (key, ts) AS
SELECT
    key.number,
    ts.number
FROM
    numbers(1, 2) AS key,
    numbers(10) AS ts
SETTINGS join_algorithm = 'hash';

SELECT
    p.key,
    p.ts,
    e.value
FROM
    probes AS p
ASOF INNER JOIN events AS e
    ON p.key = e.key
    AND p.ts >= e.begin
ORDER BY
    p.key ASC,
    p.ts ASC;

SELECT
    p.key,
    p.ts,
    e.value
FROM
    probes AS p
ASOF LEFT JOIN events AS e
    ON p.key = e.key
    AND p.ts >= e.begin
ORDER BY
    p.key ASC,
    p.ts ASC NULLS FIRST;