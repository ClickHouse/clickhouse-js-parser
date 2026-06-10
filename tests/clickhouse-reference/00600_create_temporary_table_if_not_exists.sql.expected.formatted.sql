CREATE TEMPORARY TABLE IF NOT EXISTS temporary_table
(
    column UInt32
)
ENGINE = Memory();

INSERT INTO temporary_table;

SELECT column
FROM temporary_table
ORDER BY column ASC;