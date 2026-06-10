DROP TABLE IF EXISTS `order`;

CREATE TABLE `order`
(
    ID Int64,
    Type Int64,
    Num UInt64,
    t DateTime
)
ENGINE = MergeTree()
ORDER BY (ID, Type, Num)
PARTITION BY toYYYYMMDD(t);

SYSTEM STOP MERGES `order`;

INSERT INTO `order` SELECT
    number % 2000,
    1,
    number,
    1656700561 - intDiv(intHash32(number), 1000)
FROM numbers(100000);

SELECT Num
FROM `order`
WHERE Type = 1
    AND ID = 1
ORDER BY Num ASC
LIMIT 5;

SELECT Num
FROM `order`
PREWHERE Type = 1
WHERE ID = 1
ORDER BY Num ASC
LIMIT 5;