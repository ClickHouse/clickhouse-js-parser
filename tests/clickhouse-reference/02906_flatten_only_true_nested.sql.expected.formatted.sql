SET flatten_nested = '1';

DROP TABLE IF EXISTS test_nested;

CREATE TABLE test_nested
(
    data Nested(x UInt32, y UInt32)
)
ENGINE = Memory();

DESCRIBE TABLE test_nested;

DROP TABLE test_nested;

DROP TABLE IF EXISTS test_array_tuple;

CREATE TABLE test_array_tuple
(
    data Array(Tuple(x UInt64, y UInt64))
)
ENGINE = Memory();

DESCRIBE TABLE test_array_tuple;

DROP TABLE test_array_tuple;