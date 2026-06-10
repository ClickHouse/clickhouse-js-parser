DROP TABLE IF EXISTS numbers_10;

CREATE TABLE numbers_10
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY number;

INSERT INTO numbers_10 SELECT number
FROM `system`.numbers
LIMIT 10;

SELECT
    number,
    (number, toDate('2015-01-01') + number)
FROM numbers_10
LIMIT 10
SETTINGS extremes = '1';