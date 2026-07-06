SELECT
    sumArgMin(number, number % 20),
    sumArgMax(number, number % 20)
FROM numbers(100);

SELECT
    sumArgMin(number, toString(number % 20)),
    sumArgMax(number, toString(number % 20))
FROM numbers(100);

SELECT
    sumArgMinIf(number, number % 20, number % 2 = 0),
    sumArgMaxIf(number, number % 20, number % 2 = 0)
FROM numbers(100);

SELECT sumArgMin()
FROM numbers(100); -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT sumArgMin(number)
FROM numbers(100); -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

-- Try passing a non comparable type, for example an AggregationState
SELECT sumArgMin(number, unhex('0000000000000000')::AggregateFunction(sum, UInt64))
FROM numbers(100); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

-- ASAN (data leak)
SELECT sumArgMax(number, tuple(number, repeat('a', (10 * (number % 100))::Int32)))
FROM numbers(1000);