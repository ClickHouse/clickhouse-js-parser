DROP TABLE IF EXISTS test_agg_proj_02302;

CREATE TABLE test_agg_proj_02302
(
    x Int32,
    y Int32,
    PROJECTION x_plus_y (SELECT sum(x - y), argMax(x, y) GROUP BY x + y)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1';

INSERT INTO test_agg_proj_02302 SELECT
    intDiv(number, 2),
    -intDiv(number, 3) - 1
FROM numbers(100);

-- { echoOn }
SELECT
    x + y,
    sum(x - y) AS s
FROM test_agg_proj_02302
GROUP BY x + y
ORDER BY s DESC
LIMIT 5
SETTINGS
    optimize_aggregation_in_order = '0',
    optimize_read_in_order = '0';

SELECT
    x + y,
    sum(x - y) AS s
FROM test_agg_proj_02302
GROUP BY x + y
ORDER BY s DESC
LIMIT 5
SETTINGS
    optimize_aggregation_in_order = '1',
    optimize_read_in_order = '1';

-- { echoOff }
DROP TABLE test_agg_proj_02302;