DROP TABLE IF EXISTS uin_value_details;

CREATE TABLE uin_value_details
(
    ds Date,
    uin UInt32,
    value Float32
)
ENGINE = MergeTree()
ORDER BY ds;

INSERT INTO uin_value_details (ds, uin, value);

INSERT INTO uin_value_details (ds, uin, value);

WITH (
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-26')
        FROM uin_value_details
    ) AS vec_1,

(
        SELECT groupNumericIndexedVectorStateIf(uin, value, ds = '2023-12-27')
        FROM uin_value_details
    ) AS vec_2

SELECT arrayJoin([numericIndexedVectorToMap(vec_1), numericIndexedVectorToMap(vec_2), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_1, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseAdd(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseSubtract(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseSubtract(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseSubtract(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_1, -2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_2, 8)), numericIndexedVectorToMap(numericIndexedVectorPointwiseMultiply(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseDivide(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseDivide(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseDivide(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseEqual(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseEqual(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseEqual(vec_1, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseNotEqual(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseNotEqual(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseNotEqual(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLess(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLess(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLess(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLessEqual(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLessEqual(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseLessEqual(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreater(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreater(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreater(vec_2, 0)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreaterEqual(vec_1, vec_2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreaterEqual(vec_1, 2)), numericIndexedVectorToMap(numericIndexedVectorPointwiseGreaterEqual(vec_2, 0))]);