SET enable_analyzer = '1';

SELECT * APPLY(hex)
FROM (
        SELECT
            (
                SELECT stochasticLogisticRegressionState(0.1, 0., 5, 'SGD')(number, number)
                FROM numbers(10)
            ) AS col1,
            (
                SELECT stochasticLinearRegressionState(0.1, 0., 5, 'SGD')(number, number)
                FROM numbers(10)
            ) AS col2
        FROM numbers(1)
    );

SELECT *
FROM (
        SELECT
            bitmapHasAny(bitmapBuild([toUInt8(1)]), (
                SELECT groupBitmapState(toUInt8(1))
            )) AS has1,
            bitmapHasAny(bitmapBuild([toUInt64(1)]), (
                SELECT groupBitmapState(toUInt64(2))
            )) AS has2
    );