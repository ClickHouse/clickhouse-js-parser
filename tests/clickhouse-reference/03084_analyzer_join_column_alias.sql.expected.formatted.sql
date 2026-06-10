-- https://github.com/ClickHouse/ClickHouse/issues/47432
SET enable_analyzer = '1';

CREATE TABLE t1
ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT
    1 AS user_id,
    2 AS level;

CREATE TABLE t2
ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT
    1 AS user_id,
    'website' AS event_source,
    '2023-01-01 00:00:00'::DateTime AS timestamp;

ALTER TABLE t2 ADD COLUMN date Date ALIAS toDate(timestamp);

SELECT any(t2.date) AS any_val
FROM
    t1 AS t1
LEFT JOIN t2 AS t2
    ON t1.user_id = t2.user_id;