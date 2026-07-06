-- https://github.com/ClickHouse/ClickHouse/issues/29748
SET enable_analyzer = '1';

CREATE TABLE events
(
    distinct_id String
)
ENGINE = Memory();

INSERT INTO events;

WITH cte1 AS (
    SELECT '1234' AS x
),

cte2 AS (
    SELECT '1234' AS x
)

SELECT *
FROM
    events AS events
INNER JOIN cte2
    ON cte2.x = events.distinct_id
INNER JOIN cte1
    ON cte1.x = cte2.x
LIMIT 1;