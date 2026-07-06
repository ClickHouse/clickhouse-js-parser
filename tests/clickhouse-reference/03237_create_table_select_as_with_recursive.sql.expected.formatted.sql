DROP TABLE IF EXISTS t;

SET enable_analyzer = '1';

CREATE TABLE t1
(
    a Int64,
    s DateTime('Asia/Istanbul')
)
ENGINE = MergeTree()
ORDER BY a;

CREATE VIEW t
AS
WITH RECURSIVE 42 AS ttt,

toDate(s) AS start_date,

_table AS (
    SELECT 1 AS number
    UNION ALL
    SELECT number + 1
    FROM _table
    WHERE number < 10
)

SELECT
    a,
    ttt
FROM
    t1
INNER JOIN _table
    ON t1.a = _table.number
    AND start_date = '2024-09-23';

DROP TABLE t;