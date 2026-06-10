-- Tags: zookeeper, no-encrypted-storage
-- https://github.com/ClickHouse/ClickHouse/issues/72887
DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int
)
ENGINE = Memory();

BEGIN TRANSACTION;

EXPLAIN
SELECT 1
FROM
    (
        SELECT 1
    ) AS tx
INNER JOIN t0
    ON true; -- { serverError NOT_IMPLEMENTED }

ROLLBACK;