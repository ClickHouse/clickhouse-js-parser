-- https://github.com/ClickHouse/ClickHouse/issues/33000
SET enable_analyzer = '1';

SET param_test_a = '30';

WITH 0 AS column

SELECT column AS number
FROM numbers(2)
FORMAT TSVWithNames;

WITH 0 AS column

SELECT 0 AS number
FROM numbers(2)
FORMAT TSVWithNames;

WITH 0 AS column

SELECT column
FROM numbers(2)
FORMAT TSVWithNames;