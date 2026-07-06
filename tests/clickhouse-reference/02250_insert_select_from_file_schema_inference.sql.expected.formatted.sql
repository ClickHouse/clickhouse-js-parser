SET use_structure_from_insertion_table_in_table_functions = '1';

INSERT INTO FUNCTION file(concat(database(), '.data_02250.jsonl')) SELECT (
        SELECT 1
    )
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(concat(database(), '.data_02250.jsonl')) SELECT NULL AS x
SETTINGS engine_file_truncate_on_insert = '1';

DROP TABLE IF EXISTS test_02250;

CREATE TABLE test_02250
(
    x Nullable(UInt32)
)
ENGINE = Memory();

INSERT INTO test_02250 SELECT *
FROM file(concat(database(), '.data_02250.jsonl'));

SELECT *
FROM test_02250;

DROP TABLE test_02250;