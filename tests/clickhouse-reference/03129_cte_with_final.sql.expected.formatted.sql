DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    key Int64,
    someCol String,
    eventTime DateTime
)
ENGINE = ReplacingMergeTree(eventTime)
ORDER BY key;

INSERT INTO t;

SET enable_analyzer = '1';

EXPLAIN QUERY TREE passes = '1'
WITH merged_test AS (
    SELECT *
    FROM t FINAL
)

SELECT *
FROM merged_test;

WITH merged_test AS (
    SELECT *
    FROM t FINAL
)

SELECT *
FROM merged_test;

DROP TABLE t;