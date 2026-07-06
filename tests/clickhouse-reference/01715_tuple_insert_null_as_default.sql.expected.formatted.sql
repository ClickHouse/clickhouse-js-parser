DROP TABLE IF EXISTS test_tuple;

CREATE TABLE test_tuple
(
    value Tuple(UInt8, UInt8)
)
ENGINE = TinyLog();

SET input_format_null_as_default = '1';

INSERT INTO test_tuple;

SELECT *
FROM test_tuple;

SET input_format_null_as_default = '0';

INSERT INTO test_tuple; -- { error TYPE_MISMATCH }

DROP TABLE test_tuple;

DROP TABLE IF EXISTS test_tuple_nested_in_array;

CREATE TABLE test_tuple_nested_in_array
(
    value Array(Tuple(UInt8, UInt8))
)
ENGINE = TinyLog();

INSERT INTO test_tuple_nested_in_array;

SELECT *
FROM test_tuple_nested_in_array;

INSERT INTO test_tuple_nested_in_array; -- { error TYPE_MISMATCH }

DROP TABLE test_tuple_nested_in_array;

DROP TABLE IF EXISTS test_tuple_nested_in_array_nested_in_tuple;

CREATE TABLE test_tuple_nested_in_array_nested_in_tuple
(
    value Tuple(UInt8, Array(Tuple(UInt8, UInt8)))
)
ENGINE = TinyLog();

INSERT INTO test_tuple_nested_in_array_nested_in_tuple;

SELECT *
FROM test_tuple_nested_in_array_nested_in_tuple;

INSERT INTO test_tuple_nested_in_array_nested_in_tuple; -- { error TYPE_MISMATCH }

DROP TABLE test_tuple_nested_in_array_nested_in_tuple;

DROP TABLE IF EXISTS test_tuple_nested_in_map;

CREATE TABLE test_tuple_nested_in_map
(
    value Map(String, Tuple(UInt8, UInt8))
)
ENGINE = TinyLog();

INSERT INTO test_tuple_nested_in_map;

SELECT *
FROM test_tuple_nested_in_map;

DROP TABLE test_tuple_nested_in_map;

DROP TABLE IF EXISTS test_tuple_nested_in_map_nested_in_tuple;

CREATE TABLE test_tuple_nested_in_map_nested_in_tuple
(
    value Tuple(UInt8, Map(String, Tuple(UInt8, UInt8)))
)
ENGINE = TinyLog();

INSERT INTO test_tuple_nested_in_map_nested_in_tuple;

SELECT *
FROM test_tuple_nested_in_map_nested_in_tuple;

DROP TABLE test_tuple_nested_in_map_nested_in_tuple;