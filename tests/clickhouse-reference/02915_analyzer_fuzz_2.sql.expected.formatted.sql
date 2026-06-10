SET aggregate_functions_null_for_empty = '1';

--set enable_analyzer=1;
CREATE TABLE t_delete_projection
(
    x UInt32,
    y UInt64,
    PROJECTION p (SELECT sum(y))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t_delete_projection SELECT
    number,
    toString(number)
FROM numbers(8192 * 10);