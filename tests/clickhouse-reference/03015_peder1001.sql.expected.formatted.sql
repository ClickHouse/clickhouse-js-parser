-- Tags: no-fasttest
-- no-fasttest: upper/lowerUTF8 use ICU
DROP TABLE IF EXISTS test_data;

CREATE TABLE test_data
(
    ShipmentDate Date
)
ENGINE = Memory();

INSERT INTO test_data (ShipmentDate);

SELECT toDayOfWeek(ShipmentDate) AS c
FROM test_data
WHERE c IS NOT NULL
    AND lowerUTF8(formatDateTime(plus(toDate('2024-01-01'), toIntervalDay(toInt32(c) - 1)), '%W')) LIKE '%m%'
GROUP BY c
ORDER BY c ASC
LIMIT 62
OFFSET 0;

DROP TABLE test_data;