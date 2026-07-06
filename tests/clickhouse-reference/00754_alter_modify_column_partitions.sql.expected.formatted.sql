-- check ALTER MODIFY COLUMN with partitions
SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS alter_column;

CREATE TABLE alter_column
(
    x UInt32,
    y Int32
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY x;

INSERT INTO alter_column (x, y) SELECT
    number AS x,
    -number AS y
FROM `system`.numbers
LIMIT 50;

SHOW CREATE TABLE alter_column;

SELECT *
FROM alter_column
ORDER BY _part ASC;

ALTER TABLE alter_column MODIFY COLUMN y Int64;

DROP TABLE alter_column;