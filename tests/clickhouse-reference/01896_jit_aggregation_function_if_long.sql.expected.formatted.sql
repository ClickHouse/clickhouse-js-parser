-- Tags: long
SET compile_aggregate_expressions = '1';

SET min_count_to_compile_aggregate_expression = '0';

DROP TABLE IF EXISTS test_table_unsigned_values;

CREATE TABLE test_table_unsigned_values
(
    id UInt64,
    value1 UInt8,
    value2 UInt16,
    value3 UInt32,
    value4 UInt64,
    predicate_value UInt8
)
ENGINE = TinyLog();

INSERT INTO test_table_unsigned_values SELECT
    number % 3,
    number,
    number,
    number,
    number,
    if(number % 2 = 0, 1, 0)
FROM `system`.numbers
LIMIT 120;

SELECT
    id,
    sumIf(value1, predicate_value),
    sumIf(value2, predicate_value),
    sumIf(value3, predicate_value),
    sumIf(value4, predicate_value)
FROM test_table_unsigned_values
GROUP BY id
ORDER BY id ASC;

DROP TABLE test_table_unsigned_values;

DROP TABLE IF EXISTS test_table_signed_values;

CREATE TABLE test_table_signed_values
(
    id UInt64,
    value1 Int8,
    value2 Int16,
    value3 Int32,
    value4 Int64,
    predicate_value UInt8
)
ENGINE = TinyLog();

INSERT INTO test_table_signed_values SELECT
    number % 3,
    number,
    number,
    number,
    number,
    if(number % 2 = 0, 1, 0)
FROM `system`.numbers
LIMIT 120;

SELECT
    id,
    sumIf(value1, predicate_value),
    sumIf(value2, predicate_value),
    sumIf(value3, predicate_value),
    sumIf(value4, predicate_value)
FROM test_table_signed_values
GROUP BY id
ORDER BY id ASC;

DROP TABLE test_table_signed_values;

DROP TABLE IF EXISTS test_table_float_values;

CREATE TABLE test_table_float_values
(
    id UInt64,
    value1 Float32,
    value2 Float64,
    predicate_value UInt8
)
ENGINE = TinyLog();

INSERT INTO test_table_float_values SELECT
    number % 3,
    number,
    number,
    if(number % 2 = 0, 1, 0)
FROM `system`.numbers
LIMIT 120;

SELECT
    id,
    sumIf(value1, predicate_value),
    sumIf(value2, predicate_value)
FROM test_table_float_values
GROUP BY id
ORDER BY id ASC;

DROP TABLE test_table_float_values;

DROP TABLE IF EXISTS test_table_nullable_unsigned_values;

CREATE TABLE test_table_nullable_unsigned_values
(
    id UInt64,
    value1 Nullable(UInt8),
    value2 Nullable(UInt16),
    value3 Nullable(UInt32),
    value4 Nullable(UInt64),
    predicate_value UInt8
)
ENGINE = TinyLog();

INSERT INTO test_table_nullable_unsigned_values SELECT
    number % 3,
    number,
    number,
    number,
    number,
    if(number % 2 = 0, 1, 0)
FROM `system`.numbers
LIMIT 120;

SELECT
    id,
    sumIf(value1, predicate_value),
    sumIf(value2, predicate_value),
    sumIf(value3, predicate_value),
    sumIf(value4, predicate_value)
FROM test_table_nullable_unsigned_values
GROUP BY id
ORDER BY id ASC;

DROP TABLE test_table_nullable_unsigned_values;

DROP TABLE IF EXISTS test_table_nullable_signed_values;

CREATE TABLE test_table_nullable_signed_values
(
    id UInt64,
    value1 Nullable(Int8),
    value2 Nullable(Int16),
    value3 Nullable(Int32),
    value4 Nullable(Int64),
    predicate_value UInt8
)
ENGINE = TinyLog();

INSERT INTO test_table_nullable_signed_values SELECT
    number % 3,
    number,
    number,
    number,
    number,
    if(number % 2 = 0, 1, 0)
FROM `system`.numbers
LIMIT 120;

SELECT
    id,
    sumIf(value1, predicate_value),
    sumIf(value2, predicate_value),
    sumIf(value3, predicate_value),
    sumIf(value4, predicate_value)
FROM test_table_nullable_signed_values
GROUP BY id
ORDER BY id ASC;

DROP TABLE test_table_nullable_signed_values;

DROP TABLE IF EXISTS test_table_nullable_float_values;

CREATE TABLE test_table_nullable_float_values
(
    id UInt64,
    value1 Nullable(Float32),
    value2 Nullable(Float64),
    predicate_value UInt8
)
ENGINE = TinyLog();

INSERT INTO test_table_nullable_float_values SELECT
    number % 3,
    number,
    number,
    if(number % 2 = 0, 1, 0)
FROM `system`.numbers
LIMIT 120;

SELECT
    id,
    sumIf(value1, predicate_value),
    sumIf(value2, predicate_value)
FROM test_table_nullable_float_values
GROUP BY id
ORDER BY id ASC;

DROP TABLE test_table_nullable_float_values;

DROP TABLE IF EXISTS test_table_null_specifics;

CREATE TABLE test_table_null_specifics
(
    id UInt64,
    value1 Nullable(UInt64),
    value2 Nullable(UInt64),
    value3 Nullable(UInt64),
    predicate_value UInt8
)
ENGINE = TinyLog();

INSERT INTO test_table_null_specifics;

INSERT INTO test_table_null_specifics;

INSERT INTO test_table_null_specifics;

SELECT
    id,
    sumIf(value1, predicate_value),
    sumIf(value2, predicate_value),
    sumIf(value3, predicate_value)
FROM test_table_null_specifics
GROUP BY id
ORDER BY id ASC;

CREATE TABLE test_table_null_specifics
(
    id UInt64,
    value1 Nullable(UInt64),
    value2 Nullable(UInt64),
    value3 Nullable(UInt64),
    predicate_value UInt8,
    weight UInt64
)
ENGINE = TinyLog();

INSERT INTO test_table_null_specifics;

INSERT INTO test_table_null_specifics;

INSERT INTO test_table_null_specifics;

SELECT
    id,
    avgWeightedIf(value1, weight, predicate_value),
    avgWeightedIf(value2, weight, predicate_value),
    avgWeightedIf(value3, weight, predicate_value)
FROM test_table_null_specifics
GROUP BY id
ORDER BY id ASC;