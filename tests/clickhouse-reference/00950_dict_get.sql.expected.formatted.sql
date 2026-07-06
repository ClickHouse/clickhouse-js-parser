-- Tags: no-parallel
-- Must use `default` database and these tables - they're configured in tests/*_dictionary.xml
USE default;

DROP TABLE IF EXISTS ints;

DROP TABLE IF EXISTS strings;

DROP TABLE IF EXISTS decimals;

CREATE TABLE ints
(
    key UInt64,
    i8 Int8,
    i16 Int16,
    i32 Int32,
    i64 Int64,
    u8 UInt8,
    u16 UInt16,
    u32 UInt32,
    u64 UInt64
)
ENGINE = Memory();

CREATE TABLE strings
(
    key UInt64,
    str String
)
ENGINE = Memory();

CREATE TABLE decimals
(
    key UInt64,
    d32 Decimal32(4),
    d64 Decimal64(6),
    d128 Decimal128(1)
)
ENGINE = Memory();

INSERT INTO ints;

INSERT INTO strings;

INSERT INTO decimals;

SELECT
    'dictGet',
    'flat_ints' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'i8', k),
    dictGet(dict_name, 'i16', k),
    dictGet(dict_name, 'i32', k),
    dictGet(dict_name, 'i64', k),
    dictGet(dict_name, 'u8', k),
    dictGet(dict_name, 'u16', k),
    dictGet(dict_name, 'u32', k),
    dictGet(dict_name, 'u64', k),
    dictGet(dict_name, ('i8', 'i16', 'i32'), k);

SELECT
    'dictGetOrDefault',
    'flat_ints' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGetOrDefault',
    'flat_ints' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGet',
    'hashed_ints' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'i8', k),
    dictGet(dict_name, 'i16', k),
    dictGet(dict_name, 'i32', k),
    dictGet(dict_name, 'i64', k),
    dictGet(dict_name, 'u8', k),
    dictGet(dict_name, 'u16', k),
    dictGet(dict_name, 'u32', k),
    dictGet(dict_name, 'u64', k),
    dictGet(dict_name, ('i8', 'i16', 'i32'), k);

SELECT
    'dictGetOrDefault',
    'hashed_ints' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGetOrDefault',
    'hashed_ints' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGet',
    'hashed_sparse_ints' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'i8', k),
    dictGet(dict_name, 'i16', k),
    dictGet(dict_name, 'i32', k),
    dictGet(dict_name, 'i64', k),
    dictGet(dict_name, 'u8', k),
    dictGet(dict_name, 'u16', k),
    dictGet(dict_name, 'u32', k),
    dictGet(dict_name, 'u64', k),
    dictGet(dict_name, ('i8', 'i16', 'i32'), k);

SELECT
    'dictGetOrDefault',
    'hashed_sparse_ints' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGetOrDefault',
    'hashed_sparse_ints' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGet',
    'cache_ints' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'i8', k),
    dictGet(dict_name, 'i16', k),
    dictGet(dict_name, 'i32', k),
    dictGet(dict_name, 'i64', k),
    dictGet(dict_name, 'u8', k),
    dictGet(dict_name, 'u16', k),
    dictGet(dict_name, 'u32', k),
    dictGet(dict_name, 'u64', k),
    dictGet(dict_name, ('i8', 'i16', 'i32'), k);

SELECT
    'dictGetOrDefault',
    'cache_ints' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGetOrDefault',
    'cache_ints' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGet',
    'complex_hashed_ints' AS dict_name,
    tuple(toUInt64(1)) AS k,
    dictGet(dict_name, 'i8', k),
    dictGet(dict_name, 'i16', k),
    dictGet(dict_name, 'i32', k),
    dictGet(dict_name, 'i64', k),
    dictGet(dict_name, 'u8', k),
    dictGet(dict_name, 'u16', k),
    dictGet(dict_name, 'u32', k),
    dictGet(dict_name, 'u64', k),
    dictGet(dict_name, ('i8', 'i16', 'i32'), k);

SELECT
    'dictGetOrDefault',
    'complex_hashed_ints' AS dict_name,
    tuple(toUInt64(1)) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGetOrDefault',
    'complex_hashed_ints' AS dict_name,
    tuple(toUInt64(0)) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGet',
    'complex_cache_ints' AS dict_name,
    tuple(toUInt64(1)) AS k,
    dictGet(dict_name, 'i8', k),
    dictGet(dict_name, 'i16', k),
    dictGet(dict_name, 'i32', k),
    dictGet(dict_name, 'i64', k),
    dictGet(dict_name, 'u8', k),
    dictGet(dict_name, 'u16', k),
    dictGet(dict_name, 'u32', k),
    dictGet(dict_name, 'u64', k),
    dictGet(dict_name, ('i8', 'i16', 'i32'), k);

;

SELECT
    'dictGetOrDefault',
    'complex_cache_ints' AS dict_name,
    tuple(toUInt64(1)) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

SELECT
    'dictGetOrDefault',
    'complex_cache_ints' AS dict_name,
    tuple(toUInt64(0)) AS k,
    dictGetOrDefault(dict_name, 'i8', k, toInt8(42)),
    dictGetOrDefault(dict_name, 'i16', k, toInt16(42)),
    dictGetOrDefault(dict_name, 'i32', k, toInt32(42)),
    dictGetOrDefault(dict_name, 'i64', k, toInt64(42)),
    dictGetOrDefault(dict_name, 'u8', k, toUInt8(42)),
    dictGetOrDefault(dict_name, 'u16', k, toUInt16(42)),
    dictGetOrDefault(dict_name, 'u32', k, toUInt32(42)),
    dictGetOrDefault(dict_name, 'u64', k, toUInt64(42)),
    dictGetOrDefault(dict_name, ('i8', 'i16', 'i32'), k, (toInt8(42), toInt16(42), toInt32(42)));

--
SELECT
    'dictGet',
    'flat_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'str', k),
    dictGet(dict_name, 'str', k);

SELECT
    'dictGetOrDefault',
    'flat_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'str', k, '*'),
    dictGetOrDefault(dict_name, 'str', k, '*');

SELECT
    'dictGetOrDefault',
    'flat_strings' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'str', k, '*'),
    dictGetOrDefault(dict_name, 'str', k, '*');

SELECT
    'dictGet',
    'hashed_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'str', k),
    dictGet(dict_name, 'str', k);

SELECT
    'dictGetOrDefault',
    'hashed_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'str', k, '*'),
    dictGetOrDefault(dict_name, 'str', k, '*');

SELECT
    'dictGetOrDefault',
    'hashed_strings' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'str', k, '*'),
    dictGetOrDefault(dict_name, 'str', k, '*');

SELECT
    'dictGet',
    'cache_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'str', k),
    dictGet(dict_name, 'str', k);

SELECT
    'dictGetOrDefault',
    'cache_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'str', k, '*'),
    dictGetOrDefault(dict_name, 'str', k, '*');

SELECT
    'dictGetOrDefault',
    'cache_strings' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'str', k, '*'),
    dictGetOrDefault(dict_name, 'str', k, '*');

SELECT
    'dictGet',
    'complex_hashed_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'str', tuple(k)),
    dictGet(dict_name, 'str', tuple(k));

SELECT
    'dictGetOrDefault',
    'complex_hashed_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'str', tuple(k), '*'),
    dictGetOrDefault(dict_name, 'str', tuple(k), '*');

SELECT
    'dictGetOrDefault',
    'complex_hashed_strings' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'str', tuple(k), '*'),
    dictGetOrDefault(dict_name, 'str', tuple(k), '*');

SELECT
    'dictGet',
    'complex_cache_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'str', tuple(k)),
    dictGet(dict_name, 'str', tuple(k));

SELECT
    'dictGetOrDefault',
    'complex_cache_strings' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'str', tuple(k), '*'),
    dictGetOrDefault(dict_name, 'str', tuple(k), '*');

SELECT
    'dictGetOrDefault',
    'complex_cache_strings' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'str', tuple(k), '*'),
    dictGetOrDefault(dict_name, 'str', tuple(k), '*');

--
SELECT
    'dictGet',
    'flat_decimals' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'd32', k),
    dictGet(dict_name, 'd64', k),
    dictGet(dict_name, 'd128', k),
    dictGet(dict_name, ('d32', 'd64', 'd128'), k);

SELECT
    'dictGetOrDefault',
    'flat_decimals' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGetOrDefault',
    'flat_decimals' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGet',
    'hashed_decimals' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'd32', k),
    dictGet(dict_name, 'd64', k),
    dictGet(dict_name, 'd128', k),
    dictGet(dict_name, ('d32', 'd64', 'd128'), k);

SELECT
    'dictGetOrDefault',
    'hashed_decimals' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGetOrDefault',
    'hashed_decimals' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGet',
    'cache_decimals' AS dict_name,
    toUInt64(1) AS k,
    dictGet(dict_name, 'd32', k),
    dictGet(dict_name, 'd64', k),
    dictGet(dict_name, 'd128', k),
    dictGet(dict_name, ('d32', 'd64', 'd128'), k);

SELECT
    'dictGetOrDefault',
    'cache_decimals' AS dict_name,
    toUInt64(1) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGetOrDefault',
    'cache_decimals' AS dict_name,
    toUInt64(0) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGet',
    'complex_hashed_decimals' AS dict_name,
    tuple(toUInt64(1)) AS k,
    dictGet(dict_name, 'd32', k),
    dictGet(dict_name, 'd64', k),
    dictGet(dict_name, 'd128', k),
    dictGet(dict_name, ('d32', 'd64', 'd128'), k);

SELECT
    'dictGetOrDefault',
    'complex_hashed_decimals' AS dict_name,
    tuple(toUInt64(1)) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGetOrDefault',
    'complex_hashed_decimals' AS dict_name,
    tuple(toUInt64(0)) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGet',
    'complex_cache_decimals' AS dict_name,
    tuple(toUInt64(1)) AS k,
    dictGet(dict_name, 'd32', k),
    dictGet(dict_name, 'd64', k),
    dictGet(dict_name, 'd128', k),
    dictGet(dict_name, ('d32', 'd64', 'd128'), k);

SELECT
    'dictGetOrDefault',
    'complex_cache_decimals' AS dict_name,
    tuple(toUInt64(1)) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));

SELECT
    'dictGetOrDefault',
    'complex_cache_decimals' AS dict_name,
    tuple(toUInt64(0)) AS k,
    dictGetOrDefault(dict_name, 'd32', k, toDecimal32(42, 4)),
    dictGetOrDefault(dict_name, 'd64', k, toDecimal64(42, 6)),
    dictGetOrDefault(dict_name, 'd128', k, toDecimal128(42, 1)),
    dictGetOrDefault(dict_name, ('d32', 'd64', 'd128'), k, (toDecimal32(42, 4), toDecimal64(42, 6), toDecimal128(42, 1)));