SET max_rows_to_read = 100000000000.;

SELECT *
FROM `system`.numbers
LIMIT 1000000000000.
FORMAT Null; -- { serverError TOO_MANY_ROWS }

SELECT *
FROM `system`.numbers_mt
LIMIT 1000000000000.
FORMAT Null; -- { serverError TOO_MANY_ROWS }

SELECT *
FROM `system`.zeros
LIMIT 1000000000000.
FORMAT Null; -- { serverError TOO_MANY_ROWS }

SELECT *
FROM `system`.zeros_mt
LIMIT 1000000000000.
FORMAT Null; -- { serverError TOO_MANY_ROWS }

SELECT *
FROM generateRandom()
LIMIT 1000000000000.
FORMAT Null; -- { serverError TOO_MANY_ROWS }