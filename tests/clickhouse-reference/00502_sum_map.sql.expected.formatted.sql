SET send_logs_level = 'fatal';

-- { echoOn }
DROP TABLE IF EXISTS sum_map;

CREATE TABLE sum_map
(
    date Date,
    timeslot DateTime,
    statusMap Nested(status UInt16, requests UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO sum_map;

SELECT *
FROM sum_map
ORDER BY
    timeslot ASC,
    statusMap.status ASC,
    statusMap.requests ASC;

SELECT sumMap(statusMap.status, statusMap.requests)
FROM sum_map;

SELECT sumMap((statusMap.status, statusMap.requests))
FROM sum_map;

SELECT sumMapMerge(s)
FROM (
        SELECT sumMapState(statusMap.status, statusMap.requests) AS s
        FROM sum_map
    );

SELECT
    timeslot,
    sumMap(statusMap.status, statusMap.requests)
FROM sum_map
GROUP BY timeslot
ORDER BY timeslot ASC;

SELECT
    timeslot,
    sumMap(statusMap.status, statusMap.requests).1,
    sumMap(statusMap.status, statusMap.requests).2
FROM sum_map
GROUP BY timeslot
ORDER BY timeslot ASC;

SELECT sumMapFiltered([1])(statusMap.status, statusMap.requests)
FROM sum_map;

SELECT sumMapFiltered([1, 4, 8])(statusMap.status, statusMap.requests)
FROM sum_map;

DROP TABLE sum_map;

DROP TABLE IF EXISTS sum_map_overflow;

CREATE TABLE sum_map_overflow
(
    events Array(UInt8),
    counts Array(UInt8)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO sum_map_overflow;

SELECT sumMap(events, counts)
FROM sum_map_overflow;

SELECT sumMapWithOverflow(events, counts)
FROM sum_map_overflow;

DROP TABLE sum_map_overflow;

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST(1 AS UInt64)] AS val,
            [1] AS cnt
    );

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST(1 AS Float64)] AS val,
            [1] AS cnt
    );

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST('a', 'Enum16(''a''=1)')] AS val,
            [1] AS cnt
    );

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST(1 AS DateTime('Asia/Istanbul'))] AS val,
            [1] AS cnt
    );

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST(1 AS Date)] AS val,
            [1] AS cnt
    );

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST('01234567-89ab-cdef-0123-456789abcdef' AS UUID)] AS val,
            [1] AS cnt
    );

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST(1.01, 'Decimal(10,2)')] AS val,
            [1] AS cnt
    );

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST('a' AS FixedString(1)), CAST('b' AS FixedString(1))] AS val,
            [1, 2] AS cnt
    );

SELECT sumMap(val, cnt)
FROM (
        SELECT
            [CAST('abc' AS String), CAST('ab' AS String), CAST('a' AS String)] AS val,
            [1, 2, 3] AS cnt
    );

DROP TABLE IF EXISTS sum_map_decimal;

CREATE TABLE sum_map_decimal
(
    statusMap Nested(goal_id UInt16, revenue Decimal32(5))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO sum_map_decimal;

SELECT sumMap(statusMap.goal_id, statusMap.revenue)
FROM sum_map_decimal;

SELECT sumMapWithOverflow(statusMap.goal_id, statusMap.revenue)
FROM sum_map_decimal;

DROP TABLE sum_map_decimal;

CREATE TABLE sum_map_decimal_nullable
(
    statusMap Nested(goal_id UInt16, revenue Nullable(Decimal(9, 5)))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO sum_map_decimal_nullable;

SELECT sumMap(statusMap.goal_id, statusMap.revenue)
FROM sum_map_decimal_nullable;

DROP TABLE sum_map_decimal_nullable;