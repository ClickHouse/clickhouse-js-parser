--{ echoOn }
DROP TABLE IF EXISTS `fill`;

CREATE TABLE `fill`
(
    date Date,
    val Int,
    str String
)
ENGINE = Memory();

INSERT INTO `fill`;

-- *** table without fill to compare ***
SELECT *
FROM `fill`
ORDER BY
    date ASC,
    val ASC;

-- Some useful cases
SELECT *
FROM `fill`
ORDER BY
    date ASC WITH FILL,
    val ASC;

SELECT *
FROM `fill`
ORDER BY
    date ASC WITH FILL FROM toDate('2019-05-01') TO toDate('2019-05-31'),
    val ASC WITH FILL;

SELECT *
FROM `fill`
ORDER BY
    date DESC WITH FILL,
    val ASC WITH FILL FROM 1 TO 6;

-- Some weird cases
SELECT *
FROM `fill`
ORDER BY
    date DESC WITH FILL TO toDate('2019-05-01') STEP -2,
    val DESC WITH FILL FROM 10 TO -5 STEP -3;

SELECT *
FROM `fill`
ORDER BY
    date ASC WITH FILL TO toDate('2019-06-23') STEP 3,
    val ASC WITH FILL FROM -10 STEP 2;

DROP TABLE `fill`;

CREATE TABLE `fill`
(
    a UInt32,
    b Int32
)
ENGINE = Memory();

INSERT INTO `fill`;

-- *** table without fill to compare ***
SELECT *
FROM `fill`
ORDER BY
    a ASC,
    b ASC;

SELECT *
FROM `fill`
ORDER BY
    a ASC WITH FILL,
    b ASC WITH FILL;

SELECT *
FROM `fill`
ORDER BY
    a ASC WITH FILL,
    b ASC WITH FILL TO 6 STEP 2;

SELECT *
FROM `fill`
ORDER BY a ASC WITH FILL STEP -1; -- { serverError INVALID_WITH_FILL_EXPRESSION }

SELECT *
FROM `fill`
ORDER BY a ASC WITH FILL FROM 10 TO 1; -- { serverError INVALID_WITH_FILL_EXPRESSION }

SELECT *
FROM `fill`
ORDER BY a DESC WITH FILL FROM 1 TO 10; -- { serverError INVALID_WITH_FILL_EXPRESSION }

SELECT *
FROM `fill`
ORDER BY a ASC WITH FILL FROM -10 TO 10; -- { serverError INVALID_WITH_FILL_EXPRESSION }