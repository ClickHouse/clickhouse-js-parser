-- Tags: no-random-merge-tree-settings
DROP TABLE IF EXISTS codecTest;

CREATE TABLE codecTest
(
    key UInt64,
    ref_valueU64 UInt64,
    ref_valueU32 UInt32,
    ref_valueU16 UInt16,
    ref_valueU8 UInt8,
    ref_valueI64 Int64,
    ref_valueI32 Int32,
    ref_valueI16 Int16,
    ref_valueI8 Int8,
    ref_valueDT DateTime,
    ref_valueD Date,
    valueU64 UInt64 CODEC(DoubleDelta()),
    valueU32 UInt32 CODEC(DoubleDelta()),
    valueU16 UInt16 CODEC(DoubleDelta()),
    valueU8 UInt8 CODEC(DoubleDelta()),
    valueI64 Int64 CODEC(DoubleDelta()),
    valueI32 Int32 CODEC(DoubleDelta()),
    valueI16 Int16 CODEC(DoubleDelta()),
    valueI8 Int8 CODEC(DoubleDelta()),
    valueDT DateTime CODEC(DoubleDelta()),
    valueD Date CODEC(DoubleDelta())
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', ratio_of_defaults_for_sparse_serialization = '1';

-- checking for overflow
INSERT INTO codecTest (key, ref_valueU64, valueU64, ref_valueI64, valueI64);

-- n^3 covers all double delta storage cases, from small difference between neighbouref_values (stride) to big.
INSERT INTO codecTest (key, ref_valueU64, valueU64, ref_valueU32, valueU32, ref_valueU16, valueU16, ref_valueU8, valueU8, ref_valueI64, valueI64, ref_valueI32, valueI32, ref_valueI16, valueI16, ref_valueI8, valueI8, ref_valueDT, valueDT, ref_valueD, valueD) SELECT
    number AS n,
    n * n * n AS v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    toDateTime(v),
    toDateTime(v),
    toDate(v),
    toDate(v)
FROM `system`.numbers
LIMIT 1000
OFFSET 101;

-- best case - constant stride
INSERT INTO codecTest (key, ref_valueU64, valueU64, ref_valueU32, valueU32, ref_valueU16, valueU16, ref_valueU8, valueU8, ref_valueI64, valueI64, ref_valueI32, valueI32, ref_valueI16, valueI16, ref_valueI8, valueI8, ref_valueDT, valueDT, ref_valueD, valueD) SELECT
    number AS n,
    n AS v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    toDateTime(v),
    toDateTime(v),
    toDate(v),
    toDate(v)
FROM `system`.numbers
LIMIT 1000
OFFSET 2001;

-- worst case - random stride
INSERT INTO codecTest (key, ref_valueU64, valueU64, ref_valueU32, valueU32, ref_valueU16, valueU16, ref_valueU8, valueU8, ref_valueI64, valueI64, ref_valueI32, valueI32, ref_valueI16, valueI16, ref_valueI8, valueI8, ref_valueDT, valueDT, ref_valueD, valueD) SELECT
    number AS n,
    n + (rand64() - 9223372036854775807) / 1000 AS v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    v,
    toDateTime(v),
    toDateTime(v),
    toDate(v),
    toDate(v)
FROM `system`.numbers
LIMIT 1000
OFFSET 3001;

SELECT
    key,
    ref_valueU64,
    valueU64,
    ref_valueU64 - valueU64 AS dU64
FROM codecTest
WHERE dU64 != 0
LIMIT 10;

SELECT
    key,
    ref_valueU32,
    valueU32,
    ref_valueU32 - valueU32 AS dU32
FROM codecTest
WHERE dU32 != 0
LIMIT 10;

SELECT
    key,
    ref_valueU16,
    valueU16,
    ref_valueU16 - valueU16 AS dU16
FROM codecTest
WHERE dU16 != 0
LIMIT 10;

SELECT
    key,
    ref_valueU8,
    valueU8,
    ref_valueU8 - valueU8 AS dU8
FROM codecTest
WHERE dU8 != 0
LIMIT 10;

SELECT
    key,
    ref_valueI64,
    valueI64,
    ref_valueI64 - valueI64 AS dI64
FROM codecTest
WHERE dI64 != 0
LIMIT 10;

SELECT
    key,
    ref_valueI32,
    valueI32,
    ref_valueI32 - valueI32 AS dI32
FROM codecTest
WHERE dI32 != 0
LIMIT 10;

SELECT
    key,
    ref_valueI16,
    valueI16,
    ref_valueI16 - valueI16 AS dI16
FROM codecTest
WHERE dI16 != 0
LIMIT 10;

SELECT
    key,
    ref_valueI8,
    valueI8,
    ref_valueI8 - valueI8 AS dI8
FROM codecTest
WHERE dI8 != 0
LIMIT 10;

SELECT
    key,
    ref_valueDT,
    valueDT,
    ref_valueDT - valueDT AS dDT
FROM codecTest
WHERE dDT != 0
LIMIT 10;

SELECT
    key,
    ref_valueD,
    valueD,
    ref_valueD - valueD AS dD
FROM codecTest
WHERE dD != 0
LIMIT 10;

SELECT
    table,
    name,
    type,
    compression_codec,
    data_uncompressed_bytes AS u,
    data_compressed_bytes AS c,
    round(u / c, 3) AS ratio
FROM `system`.`columns`
WHERE table = 'codecTest'
    AND database = currentDatabase()
    AND compression_codec != ''
    AND ratio <= 1
ORDER BY
    table ASC,
    name ASC,
    type ASC;