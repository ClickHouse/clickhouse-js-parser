DROP TABLE IF EXISTS data_02295;

CREATE TABLE data_02295
(
    b Int64,
    a Int64,
    grp_aggreg AggregateFunction(groupArrayArray, Array(UInt64))
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO data_02295 SELECT
    0 AS b,
    intDiv(number, 2) AS a,
    groupArrayArrayState([toUInt64(number)])
FROM numbers(4)
GROUP BY
    a,
    b;

-- { echoOn }
SELECT grp_aggreg
FROM data_02295
GROUP BY
    a,
    grp_aggreg
ORDER BY a ASC
SETTINGS optimize_aggregation_in_order = '0'
FORMAT JSONEachRow;

SELECT grp_aggreg
FROM data_02295
GROUP BY
    a,
    grp_aggreg
ORDER BY a ASC
SETTINGS optimize_aggregation_in_order = '1'
FORMAT JSONEachRow;

SELECT grp_aggreg
FROM data_02295
GROUP BY
    a,
    grp_aggreg
WITH TOTALS
ORDER BY a ASC
SETTINGS optimize_aggregation_in_order = '0'
FORMAT JSONEachRow;

SELECT grp_aggreg
FROM data_02295
GROUP BY
    a,
    grp_aggreg
WITH TOTALS
ORDER BY a ASC
SETTINGS optimize_aggregation_in_order = '1'
FORMAT JSONEachRow;

-- regression for incorrect positions passed to finalizeChunk()
SELECT
    a,
    min(b),
    max(b)
FROM data_02295
GROUP BY a
ORDER BY
    a ASC,
    count() ASC
SETTINGS optimize_aggregation_in_order = '1';

SELECT
    a,
    min(b),
    max(b)
FROM data_02295
GROUP BY a
ORDER BY
    a ASC,
    count() ASC
SETTINGS
    optimize_aggregation_in_order = '1',
    max_threads = '1';

SELECT
    a,
    min(b),
    max(b)
FROM data_02295
GROUP BY a
WITH TOTALS
ORDER BY
    a ASC,
    count() ASC
SETTINGS optimize_aggregation_in_order = '1';

SELECT
    a,
    min(b),
    max(b)
FROM data_02295
GROUP BY a
WITH TOTALS
ORDER BY
    a ASC,
    count() ASC
SETTINGS
    optimize_aggregation_in_order = '1',
    max_threads = '1';

-- { echoOff }
DROP TABLE data_02295;