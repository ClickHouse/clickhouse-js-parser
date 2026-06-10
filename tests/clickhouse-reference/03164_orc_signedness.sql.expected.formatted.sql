-- Tags: no-fasttest
SET input_format_orc_filter_push_down = '1';

SET engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(currentDatabase() || 'i8.orc') SELECT materialize(-128)::Int8 AS x;

INSERT INTO FUNCTION file(currentDatabase() || 'u8.orc') SELECT materialize(128)::UInt8 AS x;

INSERT INTO FUNCTION file(currentDatabase() || 'i16.orc') SELECT materialize(-32768)::Int16 AS x;

INSERT INTO FUNCTION file(currentDatabase() || 'u16.orc') SELECT materialize(32768)::UInt16 AS x;

INSERT INTO FUNCTION file(currentDatabase() || 'i32.orc') SELECT materialize(-2147483648)::Int32 AS x;

INSERT INTO FUNCTION file(currentDatabase() || 'u32.orc') SELECT materialize(2147483648)::UInt32 AS x;

INSERT INTO FUNCTION file(currentDatabase() || 'i64.orc') SELECT materialize(-9223372036854775808)::Int64 AS x;

INSERT INTO FUNCTION file(currentDatabase() || 'u64.orc') SELECT materialize(9223372036854775808)::UInt64 AS x;

-- { echoOn }
SELECT x
FROM file(currentDatabase() || 'i8.orc')
WHERE indexHint(x = -128);

SELECT x
FROM file(currentDatabase() || 'i8.orc')
WHERE indexHint(x = 128);

SELECT x
FROM file(currentDatabase() || 'u8.orc')
WHERE indexHint(x = -128);

SELECT x
FROM file(currentDatabase() || 'u8.orc')
WHERE indexHint(x = 128);

SELECT x
FROM file(currentDatabase() || 'i16.orc')
WHERE indexHint(x = -32768);

SELECT x
FROM file(currentDatabase() || 'i16.orc')
WHERE indexHint(x = 32768);

SELECT x
FROM file(currentDatabase() || 'u16.orc')
WHERE indexHint(x = -32768);

SELECT x
FROM file(currentDatabase() || 'u16.orc')
WHERE indexHint(x = 32768);

SELECT x
FROM file(currentDatabase() || 'i32.orc')
WHERE indexHint(x = -2147483648);

SELECT x
FROM file(currentDatabase() || 'i32.orc')
WHERE indexHint(x = 2147483648);

SELECT x
FROM file(currentDatabase() || 'u32.orc')
WHERE indexHint(x = -2147483648);

SELECT x
FROM file(currentDatabase() || 'u32.orc')
WHERE indexHint(x = 2147483648);

SELECT x
FROM file(currentDatabase() || 'i64.orc')
WHERE indexHint(x = -9223372036854775808);

SELECT x
FROM file(currentDatabase() || 'i64.orc')
WHERE indexHint(x = 9223372036854775808);

SELECT x
FROM file(currentDatabase() || 'u64.orc')
WHERE indexHint(x = -9223372036854775808);

SELECT x
FROM file(currentDatabase() || 'u64.orc')
WHERE indexHint(x = 9223372036854775808);

SELECT x
FROM file(currentDatabase() || 'u8.orc', ORC, 'x UInt8')
WHERE indexHint(x > 10);

SELECT x
FROM file(currentDatabase() || 'u8.orc', ORC, 'x UInt64')
WHERE indexHint(x > 10);

SELECT x
FROM file(currentDatabase() || 'u16.orc', ORC, 'x UInt16')
WHERE indexHint(x > 10);

SELECT x
FROM file(currentDatabase() || 'u16.orc', ORC, 'x UInt64')
WHERE indexHint(x > 10);

SELECT x
FROM file(currentDatabase() || 'u32.orc', ORC, 'x UInt32')
WHERE indexHint(x > 10);

SELECT x
FROM file(currentDatabase() || 'u32.orc', ORC, 'x UInt64')
WHERE indexHint(x > 10);

SELECT x
FROM file(currentDatabase() || 'u64.orc', ORC, 'x UInt64')
WHERE indexHint(x > 10);