SELECT toNullable(NULL);

SELECT [toNullable(NULL)];

SELECT CAST(1 AS Nullable(UInt8));

SELECT CAST(materialize(1) AS Nullable(UInt8));

SELECT [[1], [-1]];

SELECT groupArray(NULL);

SELECT [1, 2, 3][toInt8(1)];

SELECT
    arrayReduce('sumMerge', [sumState(y)]),
    finalizeAggregation(sumState(y))
FROM (
        SELECT toNullable(42) AS y
    );

SELECT arrayConcat([NULL, ''], [''], [NULL]);

SELECT CAST(NULL AS Nullable(UUID));

SELECT arrayMap((x -> substring('abc', x)), [1, 2, 3]);

SELECT 1 AS x
WHERE 1 AS x;

SELECT 1
FROM (
        SELECT 1
    )
HAVING count() > 0 AS x;

SELECT (a).1 - 1
FROM (
        SELECT (1, 2) AS a
    );

SELECT
    (a).1 - 1,
    (a).1 + 1
FROM (
        SELECT (1, 2) AS a
    );

SELECT defaultValueOfArgumentType([1])[1];

SELECT groupArrayInsertAt([2, 2], 10)([1, 1], 2);