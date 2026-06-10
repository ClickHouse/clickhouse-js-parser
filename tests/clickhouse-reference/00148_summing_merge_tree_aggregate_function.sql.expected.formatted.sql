DROP TABLE IF EXISTS summing_merge_tree_aggregate_function;

DROP TABLE IF EXISTS summing_merge_tree_null;

---- partition merge
SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE summing_merge_tree_aggregate_function
(
    d Date,
    k UInt64,
    u AggregateFunction(uniq, UInt64)
)
ENGINE = SummingMergeTree(d, k, 1);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    today() AS d,
    number AS k,
    uniqState(toUInt64(number % 500))
FROM numbers(5000)
GROUP BY
    d,
    k;

INSERT INTO summing_merge_tree_aggregate_function SELECT
    today() AS d,
    number + 5000 AS k,
    uniqState(toUInt64(number % 500))
FROM numbers(5000)
GROUP BY
    d,
    k;

SELECT count()
FROM summing_merge_tree_aggregate_function;

OPTIMIZE TABLE summing_merge_tree_aggregate_function;

DROP TABLE summing_merge_tree_aggregate_function;

CREATE TABLE summing_merge_tree_aggregate_function
(
    d MATERIALIZED today(),
    k UInt64,
    c UInt64,
    u AggregateFunction(uniq, UInt8),
    ue AggregateFunction(uniqExact, UInt8)
)
ENGINE = SummingMergeTree(d, k, 8192);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    uniqState(1),
    uniqExactState(1);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    uniqState(2),
    uniqExactState(2);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    uniqState(3),
    uniqExactState(2);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    uniqState(3),
    uniqExactState(3);

SELECT
    k,
    sum(c),
    uniqMerge(u),
    uniqExactMerge(ue)
FROM summing_merge_tree_aggregate_function
GROUP BY k;

---- sum + topK
CREATE TABLE summing_merge_tree_aggregate_function
(
    d MATERIALIZED today(),
    k UInt64,
    c UInt64,
    x AggregateFunction(topK(2), UInt8)
)
ENGINE = SummingMergeTree(d, k, 8192);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    topKState(2)(1);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    topKState(2)(2);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    topKState(2)(3);

SELECT
    k,
    sum(c),
    topKMerge(2)(x)
FROM summing_merge_tree_aggregate_function
GROUP BY k;

---- sum + topKWeighted
CREATE TABLE summing_merge_tree_aggregate_function
(
    d MATERIALIZED today(),
    k UInt64,
    c UInt64,
    x AggregateFunction(topKWeighted(2), UInt8, UInt8)
)
ENGINE = SummingMergeTree(d, k, 8192);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    topKWeightedState(2)(1, 1);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    topKWeightedState(2)(2, 2);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    1,
    topKWeightedState(2)(3, 5);

SELECT
    k,
    sum(c),
    topKWeightedMerge(2)(x)
FROM summing_merge_tree_aggregate_function
GROUP BY k;

---- avg
CREATE TABLE summing_merge_tree_aggregate_function
(
    d MATERIALIZED today(),
    k UInt64,
    x AggregateFunction(avg, Float64)
)
ENGINE = SummingMergeTree(d, k, 8192);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.125);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.25);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.375);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.4375);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.5);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.5625);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.625);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.75);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(0.875);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    avgState(1.);

SELECT
    k,
    avgMerge(x)
FROM summing_merge_tree_aggregate_function
GROUP BY k;

---- quantile
CREATE TABLE summing_merge_tree_aggregate_function
(
    d MATERIALIZED today(),
    k UInt64,
    x AggregateFunction(quantile(0.1), Float64)
)
ENGINE = SummingMergeTree(d, k, 8192);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.1);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.2);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.3);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.4);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.5);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.6);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.7);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.8);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(0.9);

INSERT INTO summing_merge_tree_aggregate_function SELECT
    1,
    quantileState(0.1)(1.);

SELECT
    k,
    round(quantileMerge(0.1)(x), 1)
FROM summing_merge_tree_aggregate_function
GROUP BY k;

---- sum + uniq with more data
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
    u AggregateFunction(uniq, UInt64)
)
ENGINE = SummingMergeTree(d, k, 8192)
AS
SELECT
    d,
    k,
    sum(c) AS c,
    uniqState(u) AS u
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
    uniqMerge(u)
FROM summing_merge_tree_aggregate_function
GROUP BY k
ORDER BY k ASC;

DROP TABLE summing_merge_tree_null;