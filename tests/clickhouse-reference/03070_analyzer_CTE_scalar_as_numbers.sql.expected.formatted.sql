-- https://github.com/ClickHouse/ClickHouse/issues/8259
SET enable_analyzer = '1';

WITH (
        SELECT 25
    ) AS something

SELECT
    *,
    something
FROM numbers(toUInt64(assumeNotNull(something)));