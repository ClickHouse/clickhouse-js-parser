SET use_structure_from_insertion_table_in_table_functions = '1';

DROP TABLE IF EXISTS test_02249;

CREATE TABLE test_02249
(
    x UInt32,
    y String
)
ENGINE = Memory();

INSERT INTO test_02249 SELECT *
FROM input() FORMAT JSONEachRow;

SELECT *
FROM test_02249;

DROP TABLE test_02249;