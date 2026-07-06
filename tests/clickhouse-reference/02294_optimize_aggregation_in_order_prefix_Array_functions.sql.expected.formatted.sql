DROP TABLE IF EXISTS data_02294;

CREATE TABLE data_02294
(
    a Int64,
    b Int64,
    grp_aggreg AggregateFunction(groupArrayArray, Array(UInt64)),
    grp_simple SimpleAggregateFunction(groupArrayArray, Array(UInt64))
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO data_02294 SELECT
    intDiv(number, 2) AS a,
    0 AS b,
    groupArrayArrayState([toUInt64(number)]),
    groupArrayArray([toUInt64(number)])
FROM numbers(4)
GROUP BY
    a,
    b;

SELECT
    arraySort(groupArrayArrayMerge(grp_aggreg)) AS gra,
    arraySort(groupArrayArray(grp_simple)) AS grs
FROM data_02294
GROUP BY
    a,
    b
SETTINGS optimize_aggregation_in_order = '1';

DROP TABLE data_02294;