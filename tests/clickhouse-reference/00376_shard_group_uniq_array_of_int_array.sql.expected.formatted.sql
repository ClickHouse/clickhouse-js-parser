-- Tags: long
SET max_rows_to_read = '55M';

DROP TABLE IF EXISTS group_uniq_arr_int;

CREATE TABLE group_uniq_arr_int
ENGINE = Memory() AS
SELECT
    g AS id,
    if(c = 0, [v], if(c = 1, emptyArrayInt64(), [v, v])) AS v
FROM (
        SELECT
            intDiv(number % 1000000, 100) AS v,
            intDiv(number % 100, 10) AS g,
            number % 10 AS c
        FROM `system`.numbers
        WHERE c < 3
        LIMIT 10000000
    );

SELECT length(groupUniqArray(v))
FROM group_uniq_arr_int
GROUP BY id
ORDER BY id ASC;

SELECT length(groupUniqArray(v))
FROM remote('127.0.0.{2,3,4,5}', currentDatabase(), 'group_uniq_arr_int')
GROUP BY id
ORDER BY id ASC;

SELECT length(groupUniqArray(10)(v))
FROM group_uniq_arr_int
GROUP BY id
ORDER BY id ASC;

SELECT length(groupUniqArray(100000)(v))
FROM group_uniq_arr_int
GROUP BY id
ORDER BY id ASC;