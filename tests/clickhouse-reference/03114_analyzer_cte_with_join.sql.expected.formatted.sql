-- Tags: no-replicated-database
-- https://github.com/ClickHouse/ClickHouse/issues/58500
SET enable_analyzer = '1';

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    ID UInt8
)
ENGINE = Memory();

INSERT INTO t;

WITH a AS (
    SELECT 1 AS column_a
),

b AS (
    SELECT 2 AS column_b
)

SELECT *
FROM
    remote('127.0.0.{1,2}', currentDatabase(), t) AS c
INNER JOIN a
    ON ID = column_a
INNER JOIN b
    ON ID = column_b;