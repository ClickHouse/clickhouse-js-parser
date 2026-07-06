SET enable_analyzer = '1';

SELECT
    CAST(tuple(1, 2) AS Tuple(value_1 UInt64, value_2 UInt64)) AS value,
    value.value_1,
    value.value_2;

SELECT '--';

SELECT
    value.value_1,
    value.value_2
FROM (
        SELECT CAST(tuple(1, 2) AS Tuple(value_1 UInt64, value_2 UInt64)) AS value
    );