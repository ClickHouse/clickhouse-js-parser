SELECT *
FROM numbers(100.)
FORMAT Null;

SELECT *
FROM numbers_mt(100.)
FORMAT Null;

SELECT *
FROM numbers_mt('100')
FORMAT Null; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT *
FROM numbers_mt(inf)
FORMAT Null; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT *
FROM numbers_mt(nan)
FORMAT Null; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }