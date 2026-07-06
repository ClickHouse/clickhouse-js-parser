DROP TABLE IF EXISTS uin_value_details_int32_int8;

CREATE TABLE uin_value_details_int32_int8
(
    ds Date,
    uin UInt32,
    value Int8
)
ENGINE = MergeTree()
ORDER BY ds;

INSERT INTO uin_value_details_int32_int8 (ds, uin, value);

INSERT INTO uin_value_details_int32_int8 (ds, uin, value);

WITH (
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-26')
        FROM uin_value_details_int32_int8
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-27')
        FROM uin_value_details_int32_int8
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2)]);

DROP TABLE IF EXISTS uin_value_details_int32_int64;

CREATE TABLE uin_value_details_int32_int64
(
    ds Date,
    uin UInt32,
    value Int64
)
ENGINE = MergeTree()
ORDER BY ds;

INSERT INTO uin_value_details_int32_int64 (ds, uin, value);

INSERT INTO uin_value_details_int32_int64 (ds, uin, value);

WITH (
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-26')
        FROM uin_value_details_int32_int64
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-27')
        FROM uin_value_details_int32_int64
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2)]);

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

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2)]);