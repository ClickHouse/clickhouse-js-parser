CREATE TEMPORARY TABLE IF NOT EXISTS default_table
(
    x UInt32,
    y UInt32 DEFAULT 42,
    z UInt32 DEFAULT 33
)
ENGINE = Memory();

INSERT INTO default_table (x);

INSERT INTO default_table (x, z);

INSERT INTO default_table;

SELECT *
FROM default_table
ORDER BY x ASC;