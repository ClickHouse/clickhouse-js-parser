DROP TABLE IF EXISTS data_02293;

CREATE TABLE data_02293
(
    a Int64,
    grp_aggreg AggregateFunction(groupArrayArray, Array(UInt64)),
    grp_simple SimpleAggregateFunction(groupArrayArray, Array(UInt64))
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO data_02293 SELECT
    1 AS a,
    groupArrayArrayState([toUInt64(number)]),
    groupArrayArray([toUInt64(number)])
FROM numbers(2)
GROUP BY a;

SELECT
    arraySort(groupArrayArrayMerge(grp_aggreg)) AS gra,
    arraySort(groupArrayArray(grp_simple)) AS grs
FROM data_02293
GROUP BY a
SETTINGS optimize_aggregation_in_order = '1';

DROP TABLE data_02293;