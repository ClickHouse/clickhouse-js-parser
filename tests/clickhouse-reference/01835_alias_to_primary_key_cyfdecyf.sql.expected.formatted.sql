DROP TABLE IF EXISTS db;

CREATE TABLE tb
(
    date Date,
    index Int32,
    value Int32,
    idx Int32 ALIAS index
)
ENGINE = MergeTree()
ORDER BY (date, index)
PARTITION BY date;

INSERT INTO tb;

SET force_primary_key = '1';

SELECT *
FROM tb
WHERE index >= 0
    AND index <= 2;

SELECT *
FROM tb
WHERE idx >= 0
    AND idx <= 2;

DROP TABLE tb;