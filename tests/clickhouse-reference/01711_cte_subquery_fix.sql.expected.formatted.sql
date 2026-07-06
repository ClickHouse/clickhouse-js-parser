DROP TABLE IF EXISTS t;

CREATE TABLE t
ENGINE = Memory() AS
WITH cte AS (
    SELECT *
    FROM numbers(10)
)

SELECT *
FROM cte;

DROP TABLE t;

DROP TABLE IF EXISTS view1;

CREATE VIEW view1
AS
WITH t AS (
    SELECT number AS n
    FROM numbers(3)
)

SELECT n
FROM t;

DROP TABLE view1;