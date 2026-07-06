SELECT round(quantileDD(0.01, 0.5)(number), 2)
FROM numbers(200);

SELECT round(quantileDD(0.0001, 0.69)(number), 2)
FROM numbers(500);

SELECT round(quantileDD(0.003, 0.42)(number), 2)
FROM numbers(200);

SELECT round(quantileDD(0.02, 0.99)(number), 2)
FROM numbers(500);

SELECT round(quantileDD(0.01, 0.5)(number), 2)
FROM (
        SELECT arrayJoin([toInt64(number), number - 10]) AS number
        FROM numbers(0, 10)
    );

SELECT round(quantileDD(0.01, 0.5)(number - 10), 2)
FROM numbers(21);

SELECT round(quantileDD(0.01, 0.99)(-number), 2)
FROM numbers(1, 500);

SELECT round(quantileDD(0.01, 0.5)(number), 2)
FROM (
        SELECT arrayJoin([toInt64(number), number - 9223372036854775808, toInt64(number + 9223372036854775798)]) AS number
        FROM numbers(0, 10)
    );

SELECT round(quantileDD(0.01, 0.42)(number), 2)
FROM (
        SELECT arrayJoin([toFloat32(number), number - 3.4028235e38, toFloat32(number + 3.4028235e38)]) AS number
        FROM numbers(0, 10)
    );

SELECT round(quantileDD(0.01, 0.69)(number), 2)
FROM (
        SELECT arrayJoin([toFloat32(number), number - 1.1754944e-38, toFloat32(number + 1.1754944e-38)]) AS number
        FROM numbers(0, 10)
    );

SELECT round(quantileDD(0.01, 0.5)(number), 2)
FROM (
        SELECT arrayJoin([toFloat32(number), nan * number]) AS number
        FROM numbers(0, 10)
    );

SELECT round(quantileDD(0.01, 0.75)(number), 2)
FROM (
        SELECT number * 10000000. AS number
        FROM numbers(20)
    );

DROP TABLE IF EXISTS `02919_ddsketch_quantile`;

CREATE TABLE `02919_ddsketch_quantile`
ENGINE = Log() AS
SELECT quantilesDDState(0.001, 0.9)(number) AS sketch
FROM numbers(1000);

INSERT INTO `02919_ddsketch_quantile` SELECT quantilesDDState(0.001, 0.9)(number + 1000)
FROM numbers(1000);

SELECT arrayMap((a -> round(a, 2)), quantilesDDMerge(0.001, 0.9)(sketch))
FROM `02919_ddsketch_quantile`;