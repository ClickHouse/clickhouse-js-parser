DROP TABLE IF EXISTS column_modify_test;

CREATE TABLE column_modify_test
(
    id UInt64,
    val String,
    other_col UInt64
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO column_modify_test;

INSERT INTO column_modify_test;

-- on 21.9 that was done via mutations mechanism
ALTER TABLE column_modify_test MODIFY COLUMN val Nullable(String);

-- but since 21.10 it only applies that to new part, so old parts keep the old schema
--SELECT * FROM system.mutations;
INSERT INTO column_modify_test;

--select name, path, type, active, modification_time from system.parts_columns where table='column_modify_test' and column='val';
-- till now everythings looks ok
--SELECT * FROM column_modify_test;
-- now we do mutation. It will affect one of the parts
-- and it what part it will update columns.txt to the latest 'correct' state w/o updating the column file!
ALTER TABLE column_modify_test UPDATE other_col = 1 WHERE id = 1 SETTINGS mutations_sync = '1';

-- row 1 is damaged now: the column files of val columns & columns.txt is out of sync!
SELECT
    *,
    throwIf(val != 'one')
FROM column_modify_test
WHERE id = 1
FORMAT CSV;