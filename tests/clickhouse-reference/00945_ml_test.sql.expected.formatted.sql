DROP TABLE IF EXISTS defaults;

CREATE TABLE IF NOT EXISTS defaults
(
    param1 Float64,
    param2 Float64,
    target Float64,
    predict1 Float64,
    predict2 Float64
)
ENGINE = Memory();

INSERT INTO defaults;

DROP TABLE IF EXISTS model;

CREATE TABLE model
ENGINE = Memory() AS
SELECT stochasticLogisticRegressionState(0.1, 0., 1., 'SGD')(target, param1, param2) AS state
FROM defaults;

SELECT ans < 1.1
    AND ans > 0.9
FROM (
        WITH (
                SELECT state
                FROM model
            ) AS model

        SELECT evalMLMethod(model, predict1, predict2) AS ans
        FROM defaults
        LIMIT 2
    );

SELECT ans > -0.1
    AND ans < 0.1
FROM (
        WITH (
                SELECT state
                FROM model
            ) AS model

        SELECT evalMLMethod(model, predict1, predict2) AS ans
        FROM defaults
        LIMIT 2
    );

DROP TABLE defaults;

DROP TABLE model;