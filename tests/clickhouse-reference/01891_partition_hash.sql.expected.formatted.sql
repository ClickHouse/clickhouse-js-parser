DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    i8 Int8,
    i16 Int16,
    i32 Int32,
    i64 Int64,
    i128 Int128,
    i256 Int256,
    u8 UInt8,
    u16 UInt16,
    u32 UInt32,
    u64 UInt64,
    u128 UInt128,
    u256 UInt256,
    id UUID,
    s String,
    fs FixedString(33),
    a Array(UInt8),
    t Tuple(UInt16, UInt32),
    d Date,
    dt DateTime('Asia/Istanbul'),
    dt64 DateTime64(3, 'Asia/Istanbul'),
    dec128 Decimal128(3),
    dec256 Decimal256(4),
    lc LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY (i8, i16, i32, i64, i128, i256, u8, u16, u32, u64, u128, u256, id, s, fs, a, t, d, dt, dt64, dec128, dec256, lc);

INSERT INTO tab;

INSERT INTO tab;

-- Here we check that partition id did not change.
-- Different result means Backward Incompatible Change. Old partitions will not be accepted by new server.
SELECT partition_id
FROM `system`.parts
WHERE table = 'tab'
    AND database = currentDatabase();