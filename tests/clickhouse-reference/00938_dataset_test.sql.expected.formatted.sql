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
SELECT stochasticLinearRegressionState(0.03, 0.00001, 2, 'Momentum')(target, param1, param2) AS state
FROM defaults;

SELECT ans > -67.
    AND ans < -66.9
FROM (
        WITH (
                SELECT state + state + state
                FROM model
            ) AS model

        SELECT evalMLMethod(model, predict1, predict2) AS ans
        FROM defaults
        ORDER BY `all` ASC
        LIMIT 1
    );

DROP TABLE defaults;

DROP TABLE model;