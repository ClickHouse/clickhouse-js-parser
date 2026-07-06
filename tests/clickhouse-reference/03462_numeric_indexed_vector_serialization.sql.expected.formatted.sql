DROP TABLE IF EXISTS uin_value_details_int32_float64;

CREATE TABLE uin_value_details_int32_float64
(
    ds Date,
    uin UInt32,
    value Float64
)
ENGINE = MergeTree()
ORDER BY ds;

INSERT INTO uin_value_details_int32_float64 (ds, uin, value);

INSERT INTO uin_value_details_int32_float64 (ds, uin, value);

WITH (
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-26')
        FROM uin_value_details_int32_float64
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-27')
        FROM uin_value_details_int32_float64
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(CAST(CAST(vec_1 AS String) AS AggregateFunction(groupNumericIndexedVector, UInt32, Float64))), numericIndexedVectorToMap(CAST(CAST(vec_2 AS String) AS AggregateFunction(groupNumericIndexedVector, UInt32, Float64)))]);

DROP TABLE IF EXISTS vector_int32_float64;

CREATE TABLE vector_int32_float64
(
    ds Date,
    vec AggregateFunction(groupNumericIndexedVector, UInt32, Float64),
    vec_str String
)
ENGINE = MergeTree()
ORDER BY ds;

INSERT INTO vector_int32_float64 (ds, vec_str, vec) SELECT
    ds,
    groupNumericIndexedVectorState(uin, value) AS vec,
    CAST(vec AS String) AS vec_str
FROM uin_value_details_int32_float64
GROUP BY ds;

SELECT
    ds,
    numericIndexedVectorToMap(vec),
    numericIndexedVectorToMap(CAST(vec_str AS AggregateFunction(groupNumericIndexedVector, UInt32, Float64)))
FROM vector_int32_float64;