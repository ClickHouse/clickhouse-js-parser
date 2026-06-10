-- https://github.com/ClickHouse/ClickHouse/issues/30231
SET allow_suspicious_low_cardinality_types = '1';

SELECT *
FROM (
        SELECT
            number,
            multiIf(CAST(number < 4 AS UInt8), toString(number), CAST(number < 8 AS LowCardinality(UInt8)), toString(number * 10), CAST(number < 12 AS Nullable(UInt8)), toString(number * 100), CAST(number < 16 AS LowCardinality(Nullable(UInt8))), toString(number * 1000), toString(number * 10000)) AS m
        FROM `system`.numbers
        LIMIT 20
    )
ORDER BY number ASC
SETTINGS short_circuit_function_evaluation = 'enable';

SELECT *
FROM (
        SELECT
            number,
            multiIf(CAST(number < 4 AS UInt8), toString(number), CAST(number < 8 AS LowCardinality(UInt8)), toString(number * 10), CAST(NULL AS Nullable(UInt8)), toString(number * 100), CAST(NULL AS LowCardinality(Nullable(UInt8))), toString(number * 1000), toString(number * 10000)) AS m
        FROM `system`.numbers
        LIMIT 20
    )
ORDER BY number ASC
SETTINGS short_circuit_function_evaluation = 'enable';

SELECT *
FROM (
        SELECT
            number,
            multiIf(CAST(number < 4 AS UInt8), toString(number), CAST(number < 8 AS LowCardinality(UInt8)), toString(number * 10)::LowCardinality(String), CAST(number < 12 AS Nullable(UInt8)), toString(number * 100)::Nullable(String), CAST(number < 16 AS LowCardinality(Nullable(UInt8))), toString(number * 1000)::LowCardinality(Nullable(String)), toString(number * 10000)) AS m
        FROM `system`.numbers
        LIMIT 20
    )
ORDER BY number ASC
SETTINGS short_circuit_function_evaluation = 'enable';