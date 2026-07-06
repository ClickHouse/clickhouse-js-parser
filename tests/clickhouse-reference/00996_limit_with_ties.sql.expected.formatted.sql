DROP TABLE IF EXISTS `ties`;

CREATE TABLE `ties`
(
    a Int
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO `ties`;

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 1 WITH TIES;

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 3 WITH TIES;

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 5 WITH TIES;

SET max_block_size = '2';

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 1 WITH TIES
OFFSET 1;

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 2 WITH TIES
OFFSET 1;

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 2 WITH TIES;

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 3 WITH TIES
OFFSET 2;

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 4 WITH TIES;

SET max_block_size = '3';

SELECT a
FROM `ties`
ORDER BY a ASC
LIMIT 2 WITH TIES
OFFSET 3;

SELECT count()
FROM (
        SELECT number > 100
        FROM numbers(2000)
        ORDER BY number > 100 ASC
        LIMIT 7 WITH TIES
        OFFSET 1
    ); --TODO replace "number > 100" with "number > 100 as n"

SELECT count()
FROM (
        SELECT
            number,
            number < 100
        FROM numbers(2000)
        ORDER BY number < 100 DESC
        LIMIT 10 WITH TIES
    );

SET max_block_size = '5';

SELECT count()
FROM (
        SELECT
            number < 100,
            number
        FROM numbers(2000)
        ORDER BY number < 100 DESC
        LIMIT 10 WITH TIES
    );

SELECT count()
FROM (
        WITH data AS (
            SELECT *
            FROM numbers(0, 10)
            UNION ALL
            SELECT *
            FROM numbers(10, 10)
        )

        SELECT
            number DIV 10 AS ten,
            number
        FROM data
        ORDER BY ten ASC
        LIMIT 6 WITH TIES
        OFFSET 8
    );

SELECT count()
FROM (
        WITH data AS (
            SELECT *
            FROM numbers(0, 10)
            UNION ALL
            SELECT *
            FROM numbers(10, 10)
        )

        SELECT
            number DIV 11 AS eleven,
            number
        FROM data
        ORDER BY eleven ASC
        LIMIT 6 WITH TIES
        OFFSET 8
    );

DROP TABLE `ties`;