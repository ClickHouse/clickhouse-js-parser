DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    x UInt32,
    y UInt32
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO tab;

INSERT INTO tab;

SELECT *
FROM tab
ORDER BY x ASC
LIMIT 3
SETTINGS optimize_read_in_order = '1';

SELECT *
FROM tab
ORDER BY x ASC
LIMIT 4
SETTINGS optimize_read_in_order = '1';