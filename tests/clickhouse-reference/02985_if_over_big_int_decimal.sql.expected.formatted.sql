SELECT sumIf(number::Int128, number % 10 = 0)
FROM numbers(1000);

SELECT sumIf(number::UInt128, number % 10 = 0)
FROM numbers(1000);

SELECT sumIf(number::Int256, number % 10 = 0)
FROM numbers(1000);

SELECT sumIf(number::UInt256, number % 10 = 0)
FROM numbers(1000);

SELECT sumIf(number::Decimal128(3), number % 10 = 0)
FROM numbers(1000);

SELECT sumIf(number::Decimal256(3), number % 10 = 0)
FROM numbers(1000);

-- Test when the condition is neither 0 nor 1
SELECT sumIf(number::Int128, number % 10)
FROM numbers(1000);

SELECT sumIf(number::UInt128, number % 10)
FROM numbers(1000);

SELECT sumIf(number::Int256, number % 10)
FROM numbers(1000);

SELECT sumIf(number::UInt256, number % 10)
FROM numbers(1000);

SELECT sumIf(number::Decimal128(3), number % 10)
FROM numbers(1000);

SELECT sumIf(number::Decimal256(3), number % 10)
FROM numbers(1000);