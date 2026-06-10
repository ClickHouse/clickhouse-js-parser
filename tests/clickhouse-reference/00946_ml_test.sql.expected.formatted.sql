DROP TABLE IF EXISTS defaults;

CREATE TABLE IF NOT EXISTS defaults
(
    param1 Float64,
    param2 Float64,
    param3 Float64,
    param4 Float64,
    param5 Float64,
    param6 Float64,
    param7 Float64,
    target Float64,
    predict1 Float64,
    predict2 Float64,
    predict3 Float64,
    predict4 Float64,
    predict5 Float64,
    predict6 Float64,
    predict7 Float64
)
ENGINE = Memory();

INSERT INTO defaults;

DROP TABLE IF EXISTS model;

CREATE TABLE model
ENGINE = Memory() AS
SELECT stochasticLinearRegressionState(0.1, 0., 5, 'SGD')(target, param1, param2, param3, param4, param5, param6, param7) AS state
FROM defaults;

WITH (
        SELECT state
        FROM model
    ) AS model

SELECT round(evalMLMethod(model, predict1, predict2, predict3, predict4, predict5, predict6, predict7), 12)
FROM defaults;

DROP TABLE defaults;

DROP TABLE model;