DROP TABLE IF EXISTS clear_column;

CREATE TABLE clear_column
(
    x UInt32,
    y UInt32
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY x;

INSERT INTO clear_column;

ALTER TABLE clear_column CLEAR COLUMN y IN PARTITION 1;

SELECT *
FROM clear_column
ORDER BY x ASC;

ALTER TABLE clear_column CLEAR COLUMN y IN PARTITION 2;

DROP TABLE clear_column;