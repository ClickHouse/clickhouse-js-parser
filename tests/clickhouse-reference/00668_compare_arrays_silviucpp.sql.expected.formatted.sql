DROP TABLE IF EXISTS `array`;

CREATE TABLE `array`
(
    arr Array(Nullable(Float64))
)
ENGINE = Memory();

INSERT INTO `array` (arr);

SELECT *
FROM `array`
WHERE arr > [12.2];

SELECT *
FROM `array`
WHERE arr > [NULL, 12.2];

SELECT *
FROM `array`
WHERE arr > [NULL, 12];

DROP TABLE `array`;