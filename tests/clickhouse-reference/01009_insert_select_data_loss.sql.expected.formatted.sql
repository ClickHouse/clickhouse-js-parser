DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT n
FROM
    (
        SELECT number AS n
        FROM numbers(20)
    ) AS nums
SEMI LEFT JOIN (
        SELECT number * 10 AS n
        FROM numbers(2)
    ) AS js2
    USING (n)
SETTINGS max_block_size = '5';

SELECT *
FROM tab
ORDER BY x ASC;

DROP TABLE tab;