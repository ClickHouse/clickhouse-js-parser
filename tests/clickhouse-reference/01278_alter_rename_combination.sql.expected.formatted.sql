DROP TABLE IF EXISTS rename_table;

CREATE TABLE rename_table
(
    key Int32,
    value1 Int32,
    value2 Int32
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO rename_table;

-- replace one with other
ALTER TABLE rename_table RENAME COLUMN value1 TO old_value1, RENAME COLUMN value2 TO value1;

SHOW CREATE TABLE rename_table;

SELECT *
FROM rename_table
FORMAT TSVWithNames;

INSERT INTO rename_table;

-- rename all columns simultaneously
ALTER TABLE rename_table RENAME COLUMN old_value1 TO v1, RENAME COLUMN value1 TO v2, RENAME COLUMN key TO k;

SELECT *
FROM rename_table
ORDER BY k ASC
FORMAT TSVWithNames;

SELECT '---polymorphic---';

DROP TABLE IF EXISTS rename_table_polymorphic;

CREATE TABLE rename_table_polymorphic
(
    key Int32,
    value1 Int32,
    value2 Int32
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '10000';

INSERT INTO rename_table_polymorphic;

ALTER TABLE rename_table_polymorphic RENAME COLUMN value1 TO old_value1, RENAME COLUMN value2 TO value1;

SHOW CREATE TABLE rename_table_polymorphic;

SELECT *
FROM rename_table_polymorphic
FORMAT TSVWithNames;

INSERT INTO rename_table_polymorphic;

-- rename all columns simultaneously
ALTER TABLE rename_table_polymorphic RENAME COLUMN old_value1 TO v1, RENAME COLUMN value1 TO v2, RENAME COLUMN key TO k;

SELECT *
FROM rename_table_polymorphic
ORDER BY k ASC
FORMAT TSVWithNames;