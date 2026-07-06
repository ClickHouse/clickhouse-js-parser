-- Tags: no-fasttest
SET max_block_size = '65505';

SELECT
    uniqTheta(x),
    uniqTheta(x),
    uniqTheta(x, y),
    uniqTheta((x, y)),
    uniqTheta(x, y, z),
    uniqTheta((x, y, z))
FROM (
        SELECT
            number % 10 AS x,
            intDiv(number, 10) % 10 AS y,
            toString(intDiv(number, 100) % 10) AS z
        FROM `system`.numbers
        LIMIT 1000
    );

SELECT
    k,
    uniqTheta(x),
    uniqTheta(x),
    uniqTheta(x, y),
    uniqTheta((x, y)),
    uniqTheta(x, y, z),
    uniqTheta((x, y, z)),
    count() AS c
FROM (
        SELECT
            (number + 10375376009059998246) * 7402567796504994643 % 131 AS k,
            number % 10 AS x,
            intDiv(number, 10) % 10 AS y,
            toString(intDiv(number, 100) % 10) AS z
        FROM `system`.numbers
        LIMIT 100000
    )
GROUP BY k
ORDER BY
    c DESC,
    k ASC
LIMIT 10;

SET count_distinct_implementation = 'uniqTheta';

SELECT countDistinct(x)
FROM (
        SELECT number % 123 AS x
        FROM `system`.numbers
        LIMIT 1000
    );

SELECT countDistinct(x, y)
FROM (
        SELECT
            number % 11 AS x,
            number % 13 AS y
        FROM `system`.numbers
        LIMIT 1000
    );

SELECT uniqThetaArray([0, 1, 1], [0, 1, 1], [0, 1, 1]);

SELECT uniqThetaArray([0, 1, 1], [0, 1, 1], [0, 1, 0]);

SELECT uniqTheta(x)
FROM (
        SELECT arrayJoin([[1, 2], [1, 2], [1, 2, 3], []]) AS x
    );

SELECT uniqTheta(x)
FROM (
        SELECT arrayJoin([[], ['a'], ['a', 'b'], []]) AS x
    );

SELECT uniqTheta(x)
FROM (
        SELECT arrayJoin([[[]], [['a', 'b']], [['a'], ['b']], [['a', 'b']]]) AS x
    );

SELECT uniqTheta(x, x)
FROM (
        SELECT arrayJoin([[], ['a'], ['a', 'b'], []]) AS x
    );

SELECT uniqTheta(x, arrayMap((elem -> [elem, elem]), x))
FROM (
        SELECT arrayJoin([[], ['a'], ['a', 'b'], []]) AS x
    );

SELECT uniqTheta(x, toString(x))
FROM (
        SELECT arrayJoin([[], ['a'], ['a', 'b'], []]) AS x
    );

SELECT uniqTheta((x, x))
FROM (
        SELECT arrayJoin([[], ['a'], ['a', 'b'], []]) AS x
    );

SELECT uniqTheta((x, arrayMap((elem -> [elem, elem]), x)))
FROM (
        SELECT arrayJoin([[], ['a'], ['a', 'b'], []]) AS x
    );

SELECT uniqTheta((x, toString(x)))
FROM (
        SELECT arrayJoin([[], ['a'], ['a', 'b'], []]) AS x
    );

SELECT uniqTheta(x)
FROM (
        SELECT arrayJoin([[], ['a'], ['a', NULL, 'b'], []]) AS x
    );

DROP TABLE IF EXISTS decimal;

CREATE TABLE decimal
(
    a Decimal32(4),
    b Decimal64(8),
    c Decimal128(8)
)
ENGINE = Memory();

SELECT (uniqTheta(a), uniqTheta(b), uniqTheta(c))
FROM (
        SELECT *
        FROM decimal
        ORDER BY a ASC
    );

INSERT INTO decimal (a, b, c) SELECT
    toDecimal32(number - 50, 4),
    toDecimal64(number - 50, 8) / 3,
    toDecimal128(number - 50, 8) / 5
FROM `system`.numbers
LIMIT 101;

DROP TABLE decimal;

SET optimize_injective_functions_inside_uniq = '1';

EXPLAIN SYNTAX
SELECT uniqTheta(x)
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT uniqTheta(x + y)
FROM (
        SELECT
            number % 2 AS x,
            number % 3 AS y
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT uniqTheta(-x)
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT uniqTheta(bitNot(x))
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT uniqTheta(bitNot(-x))
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT uniqTheta(-bitNot(-x))
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

SET optimize_injective_functions_inside_uniq = '0';

DROP TABLE IF EXISTS stored_aggregates;

-- simple
SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE stored_aggregates
(
    d Date,
    Uniq AggregateFunction(uniq, UInt64),
    UniqThetaSketch AggregateFunction(uniqTheta, UInt64)
)
ENGINE = AggregatingMergeTree(d, d, 8192);

INSERT INTO stored_aggregates SELECT
    toDate('2014-06-01') AS d,
    uniqState(number) AS Uniq,
    uniqThetaState(number) AS UniqThetaSketch
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 1000
    );

SELECT
    uniqMerge(Uniq),
    uniqThetaMerge(UniqThetaSketch)
FROM stored_aggregates;

SELECT
    d,
    uniqMerge(Uniq),
    uniqThetaMerge(UniqThetaSketch)
FROM stored_aggregates
GROUP BY d
ORDER BY d ASC;

OPTIMIZE TABLE stored_aggregates;

DROP TABLE stored_aggregates;

-- complex
CREATE TABLE stored_aggregates
(
    d Date,
    k1 UInt64,
    k2 String,
    Uniq AggregateFunction(uniq, UInt64),
    UniqThetaSketch AggregateFunction(uniqTheta, UInt64)
)
ENGINE = AggregatingMergeTree(d, (d, k1, k2), 8192);

INSERT INTO stored_aggregates SELECT
    toDate('2014-06-01') AS d,
    intDiv(number, 100) AS k1,
    toString(intDiv(number, 10)) AS k2,
    uniqState(toUInt64(number % 7)) AS Uniq,
    uniqThetaState(toUInt64(number % 7)) AS UniqThetaSketch
FROM (
        SELECT *
        FROM `system`.numbers
        LIMIT 1000
    )
GROUP BY
    d,
    k1,
    k2
ORDER BY
    d ASC,
    k1 ASC,
    k2 ASC;

SELECT
    d,
    k1,
    k2,
    uniqMerge(Uniq),
    uniqThetaMerge(UniqThetaSketch)
FROM stored_aggregates
GROUP BY
    d,
    k1,
    k2
ORDER BY
    d ASC,
    k1 ASC,
    k2 ASC;

SELECT
    d,
    k1,
    uniqMerge(Uniq),
    uniqThetaMerge(UniqThetaSketch)
FROM stored_aggregates
GROUP BY
    d,
    k1
ORDER BY
    d ASC,
    k1 ASC;

---- sum + uniq with more data
DROP TABLE IF EXISTS summing_merge_tree_null;

DROP TABLE IF EXISTS summing_merge_tree_aggregate_function;

CREATE TABLE summing_merge_tree_null
(
    d MATERIALIZED today(),
    k UInt64,
    c UInt64,
    u UInt64
)
ENGINE = Null();

CREATE MATERIALIZED VIEW summing_merge_tree_aggregate_function
(
    d Date,
    k UInt64,
    c UInt64,
    un AggregateFunction(uniq, UInt64),
    ut AggregateFunction(uniqTheta, UInt64)
)
ENGINE = SummingMergeTree(d, k, 8192)
AS
SELECT
    d,
    k,
    sum(c) AS c,
    uniqState(u) AS un,
    uniqThetaState(u) AS ut
FROM summing_merge_tree_null
GROUP BY
    d,
    k;

-- prime number 53 to avoid resonanse between %3 and %53
INSERT INTO summing_merge_tree_null SELECT
    number % 3,
    1,
    number % 53
FROM numbers(999999);

SELECT
    k,
    sum(c),
    uniqMerge(un),
    uniqThetaMerge(ut)
FROM summing_merge_tree_aggregate_function
GROUP BY k
ORDER BY k ASC;

OPTIMIZE TABLE summing_merge_tree_aggregate_function;

DROP TABLE summing_merge_tree_aggregate_function;

DROP TABLE summing_merge_tree_null;