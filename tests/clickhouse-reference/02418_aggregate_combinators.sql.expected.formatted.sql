SELECT uniqStateMap(map(1, number))
FROM numbers(10);

SELECT uniqStateForEachMapForEachMap(map(1, [map(1, [number, number])]))
FROM numbers(10);

SELECT uniqStateForEachResample(30, 75, 30)([number, number + 1], 30)
FROM numbers(10);

SELECT uniqStateMapForEachResample(30, 75, 30)([map(1, number)], 30)
FROM numbers(10);

SELECT uniqStateForEachMerge(x) AS y
FROM (
        SELECT uniqStateForEachState([number]) AS x
        FROM numbers(10)
    );

SELECT uniqMerge(y[1])
FROM (
        SELECT uniqStateForEachMerge(x) AS y
        FROM (
                SELECT uniqStateForEachState([number]) AS x
                FROM numbers(10)
            )
    );

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x Map(UInt8, AggregateFunction(uniq, UInt64))
)
ENGINE = Memory();

INSERT INTO test SELECT uniqStateMap(map(1, number))
FROM numbers(10);

SELECT *
FROM test
FORMAT Null;

SELECT mapApply(((k, v) -> (k, finalizeAggregation(v))), x)
FROM test;

TRUNCATE TABLE test;

DROP TABLE test;

CREATE TABLE test
(
    x Map(UInt8, Array(Map(UInt8, Array(AggregateFunction(uniq, UInt64)))))
)
ENGINE = Memory();

INSERT INTO test SELECT uniqStateForEachMapForEachMap(map(1, [map(1, [number, number])]))
FROM numbers(10);

SELECT mapApply(((k, v) -> (k, arrayMap((x -> mapApply(((k, v) -> (k, arrayMap((x -> finalizeAggregation(x)), v))), x)), v))), x)
FROM test;

CREATE TABLE test
(
    x Array(Array(AggregateFunction(uniq, UInt64)))
)
ENGINE = Memory();

INSERT INTO test SELECT uniqStateForEachResample(30, 75, 30)([number, number + 1], 30)
FROM numbers(10);

SELECT arrayMap((x -> arrayMap((x -> finalizeAggregation(x)), x)), x)
FROM test;

CREATE TABLE test
(
    x Array(Array(Map(UInt8, AggregateFunction(uniq, UInt64))))
)
ENGINE = Memory();

INSERT INTO test SELECT uniqStateMapForEachResample(30, 75, 30)([map(1, number)], 30)
FROM numbers(10);

SELECT arrayMap((x -> arrayMap((x -> mapApply(((k, v) -> (k, finalizeAggregation(v))), x)), x)), x)
FROM test;