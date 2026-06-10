DROP TABLE IF EXISTS table1;

CREATE TABLE table1
(
    col1 Int32,
    col2 Int32
)
ENGINE = MergeTree()
ORDER BY col1
PARTITION BY tuple();

INSERT INTO table1;

WITH NULL AS pid

SELECT
    a.col1,
    sum(a.col2) AS summ
FROM table1 AS a
PREWHERE pid IS NULL
    OR a.col2 = pid
GROUP BY a.col1;

WITH 123 AS pid

SELECT
    a.col1,
    sum(a.col2) AS summ
FROM table1 AS a
PREWHERE pid IS NULL
    OR a.col2 = pid
GROUP BY a.col1;

DROP TABLE table1;