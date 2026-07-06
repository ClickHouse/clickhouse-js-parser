SET param_q1 = [1, 2, 3, 4];

SELECT [];

SET param_q2 = [1.5, 2.5, 3.5, 4.5];

SELECT [];

SET param_q3 = [1, 2, 3, 4, 5, 6, 7, 8];

SELECT [];

SET param_q4 = [1, 2];

SELECT [];

SET param_q5 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

SELECT [];

SET param_q6 = [1, 2, 3, 4];

SELECT L2DistanceTransposed([], [1, 2, 3, 4], 32);

DROP TABLE IF EXISTS qbit_param_test;

CREATE TABLE qbit_param_test
(
    id UInt32,
    vec QBit(Float32, 4)
)
ENGINE = Memory();

INSERT INTO qbit_param_test;

SET param_q7 = [1, 1, 1, 1];

SELECT
    id,
    L2DistanceTransposed(vec, [], 4) AS dist
FROM qbit_param_test
ORDER BY id ASC;

DROP TABLE qbit_param_test;