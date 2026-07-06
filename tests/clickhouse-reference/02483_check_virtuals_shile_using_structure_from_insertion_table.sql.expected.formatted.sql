-- Tags: no-parallel
DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    line String,
    _file String,
    _path String
)
ENGINE = Memory();

INSERT INTO FUNCTION file(`02483_data`.LineAsString) SELECT 'Hello'
SETTINGS engine_file_truncate_on_insert = '1';

SET use_structure_from_insertion_table_in_table_functions = '2';

INSERT INTO test SELECT
    *,
    _file,
    _path
FROM file(`02483_data`.LineAsString);

SELECT
    line,
    _file
FROM test;

DROP TABLE test;