SET query_plan_optimize_lazy_materialization = '1';

SET query_plan_max_limit_for_lazy_materialization = '10';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x UInt64,
    y UInt64,
    a Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

INSERT INTO test SELECT
    number,
    number,
    range(number)
FROM numbers(10);

SELECT
    a.size0,
    a
FROM test
WHERE y > 5
ORDER BY y ASC
LIMIT 2;

SELECT
    a,
    a.size0
FROM test
WHERE y > 5
ORDER BY y ASC
LIMIT 2;