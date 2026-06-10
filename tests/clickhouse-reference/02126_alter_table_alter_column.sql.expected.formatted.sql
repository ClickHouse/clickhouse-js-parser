DROP TABLE IF EXISTS alter_column_02126;

CREATE TABLE alter_column_02126
(
    a Int,
    x Int,
    y Int
)
ENGINE = MergeTree()
ORDER BY a;

SHOW CREATE TABLE alter_column_02126;

ALTER TABLE alter_column_02126 MODIFY COLUMN x Float32;

ALTER TABLE alter_column_02126 MODIFY COLUMN x Float64, MODIFY COLUMN y Float32;