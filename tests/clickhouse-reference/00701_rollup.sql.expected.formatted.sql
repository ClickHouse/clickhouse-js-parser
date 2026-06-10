-- Tags: no-fasttest
DROP TABLE IF EXISTS `rollup`;

CREATE TABLE `rollup`
(
    a String,
    b Int32,
    s Int32
)
ENGINE = Memory();

INSERT INTO `rollup`;

INSERT INTO `rollup`;

INSERT INTO `rollup`;

SELECT
    a,
    b,
    sum(s),
    count()
FROM `rollup`
GROUP BY
    a,
    b
WITH ROLLUP
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b,
    sum(s),
    count()
FROM `rollup`
GROUP BY
    a,
    b
WITH ROLLUP
WITH TOTALS
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    sum(s),
    count()
FROM `rollup`
GROUP BY a
WITH ROLLUP
ORDER BY a ASC;

SELECT
    a,
    sum(s),
    count()
FROM `rollup`
GROUP BY a
WITH ROLLUP
ORDER BY a ASC;

SELECT
    a,
    sum(s),
    count()
FROM `rollup`
GROUP BY a
WITH ROLLUP
WITH TOTALS
ORDER BY a ASC;

SET group_by_two_level_threshold = '1';

SELECT
    a,
    b,
    sum(s),
    count()
FROM `rollup`
GROUP BY
    a,
    b
WITH ROLLUP
ORDER BY
    a ASC,
    b ASC;

DROP TABLE `rollup`;