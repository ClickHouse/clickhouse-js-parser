-- Tags: stateful
SET optimize_use_implicit_projections = '0';

-- the work for scalar subquery is properly accounted:
SET max_rows_to_read = '1000000';

SELECT 1 = (
        SELECT count()
        FROM test.hits
        WHERE NOT ignore(AdvEngineID)
    ); -- { serverError TOO_MANY_ROWS }

SELECT 1 IN (
        SELECT count()
        FROM test.hits
        WHERE NOT ignore(AdvEngineID)
    ); -- { serverError TOO_MANY_ROWS }

-- this query reads from the table twice:
SET max_rows_to_read = '15000000';

SELECT count() IN (
        SELECT count()
        FROM test.hits
        WHERE NOT ignore(AdvEngineID)
    )
FROM test.hits
WHERE NOT ignore(AdvEngineID); -- { serverError TOO_MANY_ROWS }

SELECT count()
FROM test.hits
WHERE CounterID > (
        SELECT count()
        FROM test.hits
        WHERE NOT ignore(AdvEngineID)
    ); -- { serverError TOO_MANY_ROWS }

-- this query is using index but have to read all the data twice.
SET max_rows_to_read = '10000000';

SELECT count()
FROM test.hits
WHERE CounterID < (
        SELECT count()
        FROM test.hits
        WHERE NOT ignore(AdvEngineID)
    ); -- { serverError TOO_MANY_ROWS }