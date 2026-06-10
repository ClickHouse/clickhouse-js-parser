-- Tags: shard, long
SET max_rows_to_read = '55M';

DROP TABLE IF EXISTS group_uniq_arr_str;

CREATE TABLE group_uniq_arr_str
ENGINE = Memory() AS
SELECT
    hex(intHash32(g)) AS id,
    if(c = 0, [hex(v)], if(c = 1, emptyArrayString(), [hex(v), hex(v)])) AS v
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
FROM group_uniq_arr_str
GROUP BY id
ORDER BY id ASC;

SELECT length(groupUniqArray(v))
FROM remote('127.0.0.{2,3,4,5}', currentDatabase(), 'group_uniq_arr_str')
GROUP BY id
ORDER BY id ASC;