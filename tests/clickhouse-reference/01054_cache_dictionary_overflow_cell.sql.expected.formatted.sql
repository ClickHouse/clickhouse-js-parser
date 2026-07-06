-- Tags: no-parallel
CREATE DATABASE IF NOT EXISTS test_01054_overflow;

DROP TABLE IF EXISTS test_01054_overflow.ints;

CREATE TABLE test_01054_overflow.ints
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

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

INSERT INTO test_01054_overflow.ints;

SELECT
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(1)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(2)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(3)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(4)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(5)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(6)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(7)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(8)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(9)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(10)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(11)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(12)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(13)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(14)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(15)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(16)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(17)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(18)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(19)),
    dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(20));

SELECT arrayMap((x -> dictGet('one_cell_cache_ints_overflow', 'i8', toUInt64(x))), `array`)
FROM (
        SELECT [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20] AS `array`
    );

DROP TABLE IF EXISTS test_01054.ints;

DROP DATABASE test_01054_overflow;