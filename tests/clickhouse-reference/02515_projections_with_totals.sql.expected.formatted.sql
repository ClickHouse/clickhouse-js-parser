DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    x UInt8,
    PROJECTION p (SELECT x GROUP BY x)
)
ENGINE = MergeTree()
ORDER BY ();

INSERT INTO t;

SET group_by_overflow_mode = 'any', max_rows_to_group_by = '1000', totals_mode = 'after_having_auto';

SELECT x
FROM t
GROUP BY x
WITH TOTALS;

SET optimize_aggregation_in_order = '1';

DROP TABLE t;