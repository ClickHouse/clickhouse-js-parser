DROP TABLE IF EXISTS `cube`;

CREATE TABLE `cube`
(
    a String,
    b Int32,
    s Int32
)
ENGINE = Memory();

INSERT INTO `cube`;

INSERT INTO `cube`;

INSERT INTO `cube`;

SELECT
    a,
    b,
    sum(s),
    count()
FROM `cube`
GROUP BY
    a,
    b
WITH CUBE
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b,
    sum(s),
    count()
FROM `cube`
GROUP BY
    a,
    b
WITH CUBE
WITH TOTALS
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b,
    sum(s),
    count()
FROM `cube`
GROUP BY
    a,
    b
WITH CUBE
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b,
    sum(s),
    count()
FROM `cube`
GROUP BY
    a,
    b
WITH CUBE
WITH TOTALS
ORDER BY
    a ASC,
    b ASC;

SET group_by_two_level_threshold = '1';

DROP TABLE `cube`;