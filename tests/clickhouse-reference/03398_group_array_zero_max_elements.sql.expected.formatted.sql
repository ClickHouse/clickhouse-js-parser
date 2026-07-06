-- Related to https://github.com/ClickHouse/ClickHouse/issues/78088
-- Asserting that groupArray* function calls with zero `max_size` argument of
-- different types (Int/UInt) will produce BAD_ARGUMENTS error
SELECT groupArray(CAST('0' AS UInt64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArray(CAST('0' AS Int64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArray(CAST('0' AS UInt64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArray(CAST('0' AS Int64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArray(CAST('0' AS UInt64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArray(CAST('0' AS Int64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySorted(CAST('0' AS UInt64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySorted(CAST('0' AS Int64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySorted(CAST('0' AS UInt64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySorted(CAST('0' AS Int64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySorted(CAST('0' AS UInt64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySorted(CAST('0' AS Int64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySample(CAST('0' AS UInt64), 123)(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySample(CAST('0' AS Int64), 123)(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySample(CAST('0' AS UInt64), 123)('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySample(CAST('0' AS Int64), 123)('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySample(CAST('0' AS UInt64), 123)(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArraySample(CAST('0' AS Int64), 123)(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayLast(CAST('0' AS UInt64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayLast(CAST('0' AS Int64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayLast(CAST('0' AS UInt64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayLast(CAST('0' AS Int64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayLast(CAST('0' AS UInt64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayLast(CAST('0' AS Int64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingSum(CAST('0' AS UInt64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingSum(CAST('0' AS Int64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingSum(CAST('0' AS UInt64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingSum(CAST('0' AS Int64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingSum(CAST('0' AS UInt64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingSum(CAST('0' AS Int64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingAvg(CAST('0' AS UInt64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingAvg(CAST('0' AS Int64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingAvg(CAST('0' AS UInt64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingAvg(CAST('0' AS Int64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingAvg(CAST('0' AS UInt64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayMovingAvg(CAST('0' AS Int64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupUniqArray(CAST('0' AS UInt64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupUniqArray(CAST('0' AS Int64))(1); -- { serverError BAD_ARGUMENTS }

SELECT groupUniqArray(CAST('0' AS UInt64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupUniqArray(CAST('0' AS Int64))('x'); -- { serverError BAD_ARGUMENTS }

SELECT groupUniqArray(CAST('0' AS UInt64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupUniqArray(CAST('0' AS Int64))(number)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }