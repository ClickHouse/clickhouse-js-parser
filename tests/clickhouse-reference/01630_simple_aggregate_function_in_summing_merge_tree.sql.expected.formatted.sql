DROP TABLE IF EXISTS test_smt;

CREATE TABLE test_smt
(
    id UInt32,
    sMap SimpleAggregateFunction(sumMap, Tuple(Array(UInt8), Array(Int64))),
    aMap AggregateFunction(sumMap, Tuple(Array(UInt8), Array(Int64)))
)
ENGINE = SummingMergeTree()
ORDER BY id
PARTITION BY tuple();

INSERT INTO test_smt SELECT
    id,
    sumMap(k),
    sumMapState(k)
FROM (
        SELECT
            2 AS id,
            arrayJoin([([0], [1]), ([0, 25], [-1, toInt64(1)])]) AS k
    )
GROUP BY
    id,
    rowNumberInAllBlocks();

SELECT
    sumMap(sMap),
    sumMapMerge(aMap)
FROM test_smt;

DROP TABLE IF EXISTS simple_agf_summing_mt;

CREATE TABLE simple_agf_summing_mt
(
    a Int64,
    grp_aggreg AggregateFunction(groupUniqArrayArray, Array(UInt64)),
    grp_simple SimpleAggregateFunction(groupUniqArrayArray, Array(UInt64))
)
ENGINE = SummingMergeTree()
ORDER BY a;

INSERT INTO simple_agf_summing_mt SELECT
    1 AS a,
    groupUniqArrayArrayState([toUInt64(number)]),
    groupUniqArrayArray([toUInt64(number)])
FROM numbers(1)
GROUP BY a;

INSERT INTO simple_agf_summing_mt SELECT
    1 AS a,
    groupUniqArrayArrayState([toUInt64(number)]),
    groupUniqArrayArray([toUInt64(number)])
FROM numbers(2)
GROUP BY a;

OPTIMIZE TABLE simple_agf_summing_mt FINAL;

SELECT
    arraySort(groupUniqArrayArrayMerge(grp_aggreg)) AS gra,
    arraySort(groupUniqArrayArray(grp_simple)) AS grs
FROM simple_agf_summing_mt
GROUP BY a;