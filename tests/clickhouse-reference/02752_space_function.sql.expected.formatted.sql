SELECT
    space(CAST('3' AS UInt8)),
    length(space(CAST('3' AS UInt8)));

SELECT
    space(CAST('3' AS UInt16)),
    length(space(CAST('3' AS UInt16)));

SELECT
    space(CAST('3' AS UInt32)),
    length(space(CAST('3' AS UInt32)));

SELECT
    space(CAST('3' AS UInt64)),
    length(space(CAST('3' AS UInt64)));

SELECT
    space(CAST('3' AS Int8)),
    length(space(CAST('3' AS Int8)));

SELECT
    space(CAST('3' AS Int16)),
    length(space(CAST('3' AS Int16)));

SELECT
    space(CAST('3' AS Int32)),
    length(space(CAST('3' AS Int32)));

SELECT
    space(CAST('3' AS Int64)),
    length(space(CAST('3' AS Int64)));

SELECT
    space(CAST('-3' AS Int8)),
    length(space(CAST('-3' AS Int8)));

SELECT
    space(CAST('-3' AS Int16)),
    length(space(CAST('-3' AS Int16)));

SELECT
    space(CAST('-3' AS Int32)),
    length(space(CAST('-3' AS Int32)));

SELECT
    space(CAST('-3' AS Int64)),
    length(space(CAST('-3' AS Int64)));

SELECT space('abc'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT space(['abc']); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT space('abc'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT space(CAST('30303030303030303030303030303030' AS UInt64)); -- { serverError TOO_LARGE_STRING_SIZE }

SELECT space(NULL);

DROP TABLE IF EXISTS defaults;

CREATE TABLE defaults
(
    u8 UInt8,
    u16 UInt16,
    u32 UInt32,
    u64 UInt64,
    i8 Int8,
    i16 Int16,
    i32 Int32,
    i64 Int64
)
ENGINE = Memory();

INSERT INTO defaults;

SELECT space(CAST('30' AS UInt8))
FROM defaults;

SELECT space(CAST('30' AS UInt16))
FROM defaults;

SELECT space(CAST('30' AS UInt32))
FROM defaults;

SELECT space(CAST('30' AS UInt64))
FROM defaults;

SELECT space(CAST('30' AS Int8))
FROM defaults;

SELECT space(CAST('30' AS Int16))
FROM defaults;

SELECT space(CAST('30' AS Int32))
FROM defaults;

SELECT space(CAST('30' AS Int64))
FROM defaults;

SELECT
    space(u8),
    length(space(u8))
FROM defaults;

SELECT
    space(u16),
    length(space(u16))
FROM defaults;

SELECT
    space(u32),
    length(space(u32))
FROM defaults;

SELECT
    space(u64),
    length(space(u64))
FROM defaults;

SELECT
    space(i8),
    length(space(i8))
FROM defaults;

SELECT
    space(i16),
    length(space(i16))
FROM defaults;

SELECT
    space(i32),
    length(space(i32))
FROM defaults;

SELECT
    space(i64),
    length(space(i64))
FROM defaults;

DROP TABLE defaults;