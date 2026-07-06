DROP TABLE IF EXISTS uin_value_details;

CREATE TABLE uin_value_details
(
    ds Date,
    uin UInt32,
    value Float64
)
ENGINE = MergeTree()
ORDER BY ds;

INSERT INTO uin_value_details (ds, uin, value) SELECT
    '2023-12-20',
    number,
    number * number
FROM numbers(1000);

INSERT INTO uin_value_details (ds, uin, value) SELECT
    '2023-12-21',
    number,
    number
FROM numbers(1000);

WITH (
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-20')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-21')
        FROM uin_value_details
    ) AS vec_2,

numericIndexedVectorPointwiseDivide(vec_1, vec_2) AS vec_3

SELECT arrayJoin([numericIndexedVectorShortDebugString(vec_1), toString(numericIndexedVectorAllValueSum(vec_1)), numericIndexedVectorShortDebugString(vec_2), toString(numericIndexedVectorAllValueSum(vec_2)), numericIndexedVectorShortDebugString(vec_3), toString(numericIndexedVectorAllValueSum(vec_3))]);

INSERT INTO uin_value_details (ds, uin, value) SELECT
    '2023-12-22',
    number,
    number * number
FROM numbers(5000);

INSERT INTO uin_value_details (ds, uin, value) SELECT
    '2023-12-23',
    number,
    number
FROM numbers(5000);

WITH (
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-22')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-23')
        FROM uin_value_details
    ) AS vec_2,

numericIndexedVectorPointwiseDivide(vec_1, vec_2) AS vec_3

SELECT arrayJoin([numericIndexedVectorShortDebugString(vec_1), toString(numericIndexedVectorAllValueSum(vec_1)), numericIndexedVectorShortDebugString(vec_2), toString(numericIndexedVectorAllValueSum(vec_2)), numericIndexedVectorShortDebugString(vec_3), toString(numericIndexedVectorAllValueSum(vec_3))]);

INSERT INTO uin_value_details (ds, uin, value) SELECT
    '2023-12-26',
    number,
    number * number
FROM numbers(30000);

INSERT INTO uin_value_details (ds, uin, value) SELECT
    '2023-12-27',
    number,
    number
FROM numbers(30000);

INSERT INTO uin_value_details (ds, uin, value) SELECT
    '2023-12-28',
    number * 3,
    number * 3 * number * 3
FROM numbers(30000);

INSERT INTO uin_value_details (ds, uin, value) SELECT
    '2023-12-29',
    number * 3,
    number * 3
FROM numbers(30000);

WITH (
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-28')
        FROM uin_value_details
    ) AS vec_3,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-29')
        FROM uin_value_details
    ) AS vec_4,

numericIndexedVectorPointwiseDivide(vec_1, vec_2) AS vec_5,

numericIndexedVectorPointwiseDivide(vec_1, vec_3) AS vec_6,

numericIndexedVectorPointwiseDivide(vec_1, vec_4) AS vec_7,

numericIndexedVectorPointwiseDivide(vec_2, vec_3) AS vec_8,

numericIndexedVectorPointwiseDivide(vec_2, vec_4) AS vec_9,

numericIndexedVectorPointwiseDivide(vec_3, vec_4) AS vec_10

SELECT arrayJoin([numericIndexedVectorShortDebugString(vec_1), toString(numericIndexedVectorAllValueSum(vec_1)), numericIndexedVectorShortDebugString(vec_2), toString(numericIndexedVectorAllValueSum(vec_2)), numericIndexedVectorShortDebugString(vec_3), toString(numericIndexedVectorAllValueSum(vec_3)), numericIndexedVectorShortDebugString(vec_4), toString(numericIndexedVectorAllValueSum(vec_4)), numericIndexedVectorShortDebugString(vec_5), toString(numericIndexedVectorAllValueSum(vec_5)), numericIndexedVectorShortDebugString(vec_6), toString(numericIndexedVectorAllValueSum(vec_6)), numericIndexedVectorShortDebugString(vec_7), toString(numericIndexedVectorAllValueSum(vec_7)), numericIndexedVectorShortDebugString(vec_8), toString(numericIndexedVectorAllValueSum(vec_8)), numericIndexedVectorShortDebugString(vec_9), toString(numericIndexedVectorAllValueSum(vec_9)), numericIndexedVectorShortDebugString(vec_10), toString(numericIndexedVectorAllValueSum(vec_10))]);

DROP TABLE IF EXISTS numeric_indexed_vector;

CREATE TABLE numeric_indexed_vector
(
    ds Date,
    vector AggregateFunction(groupNumericIndexedVector, UInt32, Float64)
)
ENGINE = MergeTree()
ORDER BY ds;

INSERT INTO numeric_indexed_vector (ds);