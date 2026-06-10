SET optimize_injective_functions_inside_uniq = '1';

EXPLAIN SYNTAX
SELECT
    uniq(x),
    uniqExact(x),
    uniqHLL12(x),
    uniqCombined(x),
    uniqCombined64(x)
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT
    uniq(x + y),
    uniqExact(x + y),
    uniqHLL12(x + y),
    uniqCombined(x + y),
    uniqCombined64(x + y)
FROM (
        SELECT
            number % 2 AS x,
            number % 3 AS y
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT
    uniq(-x),
    uniqExact(-x),
    uniqHLL12(-x),
    uniqCombined(-x),
    uniqCombined64(-x)
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT
    uniq(bitNot(x)),
    uniqExact(bitNot(x)),
    uniqHLL12(bitNot(x)),
    uniqCombined(bitNot(x)),
    uniqCombined64(bitNot(x))
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT
    uniq(bitNot(-x)),
    uniqExact(bitNot(-x)),
    uniqHLL12(bitNot(-x)),
    uniqCombined(bitNot(-x)),
    uniqCombined64(bitNot(-x))
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT
    uniq(-bitNot(-x)),
    uniqExact(-bitNot(-x)),
    uniqHLL12(-bitNot(-x)),
    uniqCombined(-bitNot(-x)),
    uniqCombined64(-bitNot(-x))
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT countDistinct(-bitNot(-x))
FROM (
        SELECT number % 2 AS x
        FROM numbers(10)
    );

EXPLAIN SYNTAX
SELECT uniq(concatAssumeInjective('x', 'y'))
FROM numbers(10);

SET optimize_injective_functions_inside_uniq = '0';