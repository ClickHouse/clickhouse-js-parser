SET enable_analyzer = '1';

-- For function count, rewrite countState to countStateIf changes the type from AggregateFunction(count, Nullable(UInt64)) to AggregateFunction(count, UInt64)
-- We can cast AggregateFunction(count, UInt64) back to AggregateFunction(count, Nullable(UInt64)) with additional _CAST
SELECT hex(countState(if(toNullable(number % 2 = 0), number, NULL)))
FROM numbers(5)
SETTINGS optimize_rewrite_aggregate_function_with_if = '1';

SELECT toTypeName(countState(if(toNullable(number % 2 = 0), number, NULL)))
FROM numbers(5)
SETTINGS optimize_rewrite_aggregate_function_with_if = '1';

SELECT arrayStringConcat(arraySlice(splitByString(', ', trimLeft(`explain`)), 2), ', ')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN QUERY TREE', '', (
                SELECT hex(countState(if(toNullable(number % 2 = 0), number, NULL)))
                FROM numbers(5)
                SETTINGS optimize_rewrite_aggregate_function_with_if = '1'
            ))
    )
WHERE `explain` LIKE '%AggregateFunction%';

-- For function uniq, rewrite uniqState to uniqStateIf changes the type from AggregateFunction(uniq, Nullable(UInt64)) to AggregateFunction(uniq, UInt64)
-- We can't cast AggregateFunction(uniq, UInt64) back to AggregateFunction(uniq, Nullable(UInt64)) so rewrite is not happening.
SELECT toTypeName(uniqState(if(toNullable(number % 2 = 0), number, NULL)))
FROM numbers(5)
SETTINGS optimize_rewrite_aggregate_function_with_if = '1';

SELECT hex(uniqState(if(toNullable(number % 2 = 0), number, NULL)))
FROM numbers(5)
SETTINGS optimize_rewrite_aggregate_function_with_if = '1';

SELECT arrayStringConcat(arraySlice(splitByString(', ', trimLeft(`explain`)), 2), ', ')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN QUERY TREE', '', (
                SELECT hex(uniqState(if(toNullable(number % 2 = 0), number, NULL)))
                FROM numbers(5)
                SETTINGS optimize_rewrite_aggregate_function_with_if = '1'
            ))
    )
WHERE `explain` LIKE '%AggregateFunction%';

SELECT '----';

CREATE TABLE a
(
    a_id String
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY tuple();

CREATE TABLE b
(
    b_id AggregateFunction(uniq, Nullable(String))
)
ENGINE = AggregatingMergeTree()
ORDER BY tuple()
PARTITION BY tuple();

CREATE MATERIALIZED VIEW mv
TO b
(
    b_id AggregateFunction(uniq, Nullable(String))
)
AS
SELECT uniqState(if(a_id != '', a_id, NULL)) AS b_id
FROM a;