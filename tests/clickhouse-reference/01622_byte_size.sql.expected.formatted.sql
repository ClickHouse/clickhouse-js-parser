DROP TABLE IF EXISTS test_byte_size_number0;

CREATE TABLE test_byte_size_number0
(
    key Int32,
    u8 UInt8,
    u16 UInt16,
    u32 UInt32,
    u64 UInt64,
    u256 UInt256,
    i8 Int8,
    i16 Int16,
    i32 Int32,
    i64 Int64,
    i128 Int128,
    i256 Int256,
    f32 Float32,
    f64 Float64
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test_byte_size_number0;

INSERT INTO test_byte_size_number0;

SELECT
    key,
    toTypeName(u8),
    byteSize(u8),
    toTypeName(u16),
    byteSize(u16),
    toTypeName(u32),
    byteSize(u32),
    toTypeName(u64),
    byteSize(u64),
    toTypeName(u256),
    byteSize(u256)
FROM test_byte_size_number0
ORDER BY key ASC;

SELECT
    key,
    toTypeName(i8),
    byteSize(i8),
    toTypeName(i16),
    byteSize(i16),
    toTypeName(i32),
    byteSize(i32),
    toTypeName(i64),
    byteSize(i64),
    toTypeName(i128),
    byteSize(i128),
    toTypeName(u256),
    byteSize(u256)
FROM test_byte_size_number0
ORDER BY key ASC;

SELECT
    key,
    toTypeName(f32),
    byteSize(f32),
    toTypeName(f64),
    byteSize(f64)
FROM test_byte_size_number0
ORDER BY key ASC;

DROP TABLE IF EXISTS test_byte_size_number1;

CREATE TABLE test_byte_size_number1
(
    key Int32,
    date Date,
    dt DateTime,
    dt64 DateTime64(3),
    en8 Enum8('a' = 1, 'b' = 2, 'c' = 3, 'd' = 4),
    en16 Enum16('c' = 100, 'l' = 101, 'i' = 102, 'ck' = 103, 'h' = 104, 'o' = 105, 'u' = 106, 's' = 107, 'e' = 108),
    dec32 Decimal32(4),
    dec64 Decimal64(8),
    dec128 Decimal128(16),
    dec256 Decimal256(16),
    uuid UUID
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test_byte_size_number1;

INSERT INTO test_byte_size_number1;

SELECT
    key,
    byteSize(*),
    toTypeName(date),
    byteSize(date),
    toTypeName(dt),
    byteSize(dt),
    toTypeName(dt64),
    byteSize(dt64),
    toTypeName(uuid),
    byteSize(uuid)
FROM test_byte_size_number1
ORDER BY key ASC;

SELECT
    1,
    byteSize(1),
    256,
    byteSize(256),
    65536,
    byteSize(65536),
    4294967296,
    byteSize(4294967296),
    0.5,
    byteSize(0.5),
    1e-10,
    byteSize(1e-10);

SELECT
    toDate('2020-01-01'),
    byteSize(toDate('2020-01-01')),
    toDateTime('2020-01-01 01:02:03'),
    byteSize(toDateTime('2020-01-01 01:02:03')),
    toDateTime64('2020-01-01 01:02:03', 3),
    byteSize(toDateTime64('2020-01-01 01:02:03', 3));

SELECT
    toTypeName(generateUUIDv4()),
    byteSize(generateUUIDv4());

DROP TABLE IF EXISTS test_byte_size_string;

CREATE TABLE test_byte_size_string
(
    key Int32,
    str1 String,
    str2 String,
    fstr1 FixedString(8),
    fstr2 FixedString(8)
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test_byte_size_string;

INSERT INTO test_byte_size_string;

SELECT
    key,
    byteSize(*),
    str1,
    byteSize(str1),
    str2,
    byteSize(str2),
    fstr1,
    byteSize(fstr1),
    fstr2,
    byteSize(fstr2)
FROM test_byte_size_string
ORDER BY key ASC;

SELECT
    'constants: ',
    '',
    byteSize(''),
    'a',
    byteSize('a'),
    'abcde',
    byteSize('abcde');

-- simple arrays --
DROP TABLE IF EXISTS test_byte_size_array;

CREATE TABLE test_byte_size_array
(
    key Int32,
    uints8 Array(UInt8),
    ints8 Array(Int8),
    ints32 Array(Int32),
    floats32 Array(Float32),
    decs32 Array(Decimal32(4)),
    dates Array(Date),
    uuids Array(UUID)
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test_byte_size_array;

INSERT INTO test_byte_size_array;

INSERT INTO test_byte_size_array;

INSERT INTO test_byte_size_array;

SELECT
    key,
    byteSize(*),
    uints8,
    byteSize(uints8),
    ints8,
    byteSize(ints8),
    ints32,
    byteSize(ints32),
    floats32,
    byteSize(floats32),
    decs32,
    byteSize(decs32),
    dates,
    byteSize(dates),
    uuids,
    byteSize(uuids)
FROM test_byte_size_array
ORDER BY key ASC;

SELECT
    'constants:',
    [],
    byteSize([]),
    [1, 1],
    byteSize([1, 1]),
    [-1, -1],
    byteSize([-1, -1]),
    toTypeName([256, 256]),
    byteSize([256, 256]),
    toTypeName([1.1, 1.1]),
    byteSize([1.1, 1.1]);

SELECT
    'constants:',
    [toDecimal32(1.1, 4), toDecimal32(1.1, 4)],
    byteSize([toDecimal32(1.1, 4), toDecimal32(1.1, 4)]),
    [toDate('2020-01-01'), toDate('2020-01-01')],
    byteSize([toDate('2020-01-01'), toDate('2020-01-01')]);

SELECT
    'constants:',
    [toUUID('61f0c404-5cb3-11e7-907b-a6006ad3dba0'), toUUID('61f0c404-5cb3-11e7-907b-a6006ad3dba0')],
    byteSize([toUUID('61f0c404-5cb3-11e7-907b-a6006ad3dba0'), toUUID('61f0c404-5cb3-11e7-907b-a6006ad3dba0')]);

-- complex arrays --
DROP TABLE IF EXISTS test_byte_size_complex_array;

CREATE TABLE test_byte_size_complex_array
(
    key Int32,
    ints Array(Int32),
    int_ints Array(Array(Int32)),
    strs Array(String),
    str_strs Array(Array(String))
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test_byte_size_complex_array;

INSERT INTO test_byte_size_complex_array;

INSERT INTO test_byte_size_complex_array;

INSERT INTO test_byte_size_complex_array;

SELECT
    key,
    byteSize(*),
    ints,
    byteSize(ints),
    int_ints,
    byteSize(int_ints)
FROM test_byte_size_complex_array
ORDER BY key ASC;

SELECT
    'constants:',
    [[], [1, 2], [0, 65536]],
    toTypeName([[], [1, 2], [0, 65536]]),
    byteSize([[], [1, 2], [0, 65536]]);

-- select key, byteSize(*), strs, byteSize(strs), str_strs, byteSize(str_strs) from test_byte_size_complex_array order by key;
SELECT
    key,
    byteSize(*),
    strs,
    byteSize(strs),
    str_strs,
    byteSize(str_strs)
FROM test_byte_size_complex_array
ORDER BY key ASC;

SELECT
    'constants:',
    [[], [''], ['', 'a']],
    byteSize([[], [''], ['', 'a']]);

-- others --
DROP TABLE IF EXISTS test_byte_size_other;

CREATE TABLE test_byte_size_other
(
    key Int32,
    opt_int32 Nullable(Int32),
    opt_str Nullable(String),
    tuple Tuple(Int32, Nullable(String)),
    strings LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test_byte_size_other;

INSERT INTO test_byte_size_other;

INSERT INTO test_byte_size_other;

SELECT
    key,
    byteSize(*),
    opt_int32,
    byteSize(opt_int32),
    opt_str,
    byteSize(opt_str),
    tuple,
    byteSize(tuple),
    strings,
    byteSize(strings)
FROM test_byte_size_other
ORDER BY key ASC;

SELECT
    'constants:',
    NULL,
    byteSize(NULL),
    tuple(65536, NULL),
    byteSize(tuple(65536, NULL)),
    tuple(65536, toNullable('a')),
    byteSize(tuple(65536, toNullable('a')));

SELECT
    'constants:',
    toLowCardinality('abced'),
    toTypeName(toLowCardinality('abced')),
    byteSize(toLowCardinality('abced'));

-- more complex fields --
DROP TABLE IF EXISTS test_byte_size_more_complex;

CREATE TABLE test_byte_size_more_complex
(
    key Int32,
    complex1 Array(Tuple(Nullable(FixedString(4)), Array(Tuple(Nullable(String), String))))
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO test_byte_size_more_complex;

INSERT INTO test_byte_size_more_complex;

INSERT INTO test_byte_size_more_complex;

INSERT INTO test_byte_size_more_complex;

INSERT INTO test_byte_size_more_complex;

INSERT INTO test_byte_size_more_complex;

SELECT
    key,
    byteSize(*),
    complex1,
    byteSize(complex1)
FROM test_byte_size_more_complex
ORDER BY key ASC;

SELECT
    'constants:',
    tuple(NULL, []),
    byteSize(tuple(NULL, [])),
    tuple(toNullable(toFixedString('a', 4)), []),
    byteSize(tuple(toNullable(toFixedString('a', 4)), [])),
    tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a')]),
    byteSize(tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a')])),
    tuple(toFixedString('a', 4), [tuple(NULL, 'a'), tuple(NULL, 'a')]),
    byteSize(tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a'), tuple(NULL, 'a')]));

SELECT
    'constants:',
    [tuple(NULL, []), tuple(toNullable(toFixedString('a', 4)), []), tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a')]), tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a'), tuple(NULL, 'a')])];

SELECT
    'constants:',
    toTypeName([tuple(NULL, []), tuple(toNullable(toFixedString('a', 4)), []), tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a')]), tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a'), tuple(NULL, 'a')])]);

SELECT
    'constants:',
    byteSize([tuple(NULL, []), tuple(toNullable(toFixedString('a', 4)), []), tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a')]), tuple(toNullable(toFixedString('a', 4)), [tuple(NULL, 'a'), tuple(NULL, 'a')])]);