DROP TABLE IF EXISTS grop_uniq_array_date;

CREATE TABLE grop_uniq_array_date
(
    d Date,
    dt DateTime,
    id Integer
)
ENGINE = Memory();

INSERT INTO grop_uniq_array_date;

SELECT
    groupUniqArray(d),
    groupUniqArray(dt)
FROM grop_uniq_array_date;

INSERT INTO grop_uniq_array_date;

SELECT
    length(groupUniqArray(2)(d)),
    length(groupUniqArray(2)(dt)),
    length(groupUniqArray(d)),
    length(groupUniqArray(dt))
FROM grop_uniq_array_date
GROUP BY id
ORDER BY id ASC;

SELECT
    length(groupUniqArray(10000)(d)),
    length(groupUniqArray(10000)(dt))
FROM grop_uniq_array_date
GROUP BY id
ORDER BY id ASC;