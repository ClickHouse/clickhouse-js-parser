-- https://github.com/ClickHouse/ClickHouse/issues/14739
SET enable_analyzer = '1';

DROP TABLE IF EXISTS test_subquery;

CREATE TABLE test_subquery
ENGINE = Memory() AS
SELECT 'base' AS my_field;

-- query 1
SELECT my_field
FROM (
        SELECT
            *,
            'redefined' AS my_field
        FROM test_subquery
    );

-- query 2
SELECT my_field
FROM (
        SELECT
            'redefined' AS my_field,
            *
        FROM test_subquery
    );

-- query 3
SELECT my_field
FROM (
        SELECT
            *,
            'redefined' AS my_field
        FROM (
                SELECT *
                FROM test_subquery
            )
    );