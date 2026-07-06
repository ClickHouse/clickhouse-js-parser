DROP TABLE IF EXISTS t;

SET enable_analyzer = '1';

CREATE TABLE t
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO t SELECT
    number % 2,
    number
FROM numbers(10);

SET optimize_distinct_in_order = '1';

SELECT trimBoth(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT DISTINCT a
                FROM t
            ))
    )
WHERE `explain` LIKE '%InOrder%';