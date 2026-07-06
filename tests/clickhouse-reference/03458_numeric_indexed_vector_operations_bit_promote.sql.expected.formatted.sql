DROP TABLE IF EXISTS uin_value_details;

CREATE TABLE uin_value_details
(
    ds Date,
    uin UInt32,
    value Float64
)
ENGINE = MergeTree()
ORDER BY ds;

INSERT INTO uin_value_details (ds, uin, value);

INSERT INTO uin_value_details (ds, uin, value);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 24)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 24)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_1, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_2, 0))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 15)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 23)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseSubtract(vec_1, vec_2))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 15)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 23)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorShortDebugString(vec_1), numericIndexedVectorShortDebugString(vec_2), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseAdd(vec_1, vec_2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseSubtract(vec_1, vec_2))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 0)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 0)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(numericIndexedVectorPointwiseEqual(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseEqual(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseEqual(vec_1, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseNotEqual(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseNotEqual(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseNotEqual(vec_2, 0))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 0)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 0)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorShortDebugString(vec_1), numericIndexedVectorShortDebugString(vec_2), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseEqual(vec_1, vec_2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseEqual(vec_1, 2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseEqual(vec_1, 0)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseNotEqual(vec_1, vec_2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseNotEqual(vec_1, 2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseNotEqual(vec_2, 0))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 0)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 0)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(numericIndexedVectorPointwiseLess(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLess(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLess(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLessEqual(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLessEqual(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLessEqual(vec_2, 0))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 0)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 0)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreater(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreater(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreater(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreaterEqual(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreaterEqual(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreaterEqual(vec_2, 0))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 15)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 0)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_1, -2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_2, 8)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_2, 0))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 0)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 0)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(numericIndexedVectorPointwiseDivide(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseDivide(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseDivide(vec_2, 0))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 32, 0)(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 0)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorShortDebugString(vec_1), numericIndexedVectorShortDebugString(vec_2), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseDivide(vec_1, vec_2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseDivide(vec_1, 2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseDivide(vec_2, 0))]);

WITH (
        SELECT groupNumericIndexedVectorStateIf('BSI', 0, 0)(uin, value, ds = '2023-12-28')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf('BSI', 24, 24)(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorShortDebugString(vec_1), numericIndexedVectorShortDebugString(vec_2), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseLess(vec_1, vec_2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseAdd(vec_1, 2)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseAdd(vec_1, 0)), numericIndexedVectorShortDebugString(numericIndexedVectorPointwiseAdd(vec_2, 0))]);