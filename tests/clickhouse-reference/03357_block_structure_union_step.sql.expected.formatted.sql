CREATE TABLE pk_block_union
(
    d Date DEFAULT '2000-01-01',
    x DateTime,
    y UInt64,
    z UInt64
)
ENGINE = MergeTree()
ORDER BY (toStartOfMinute(x), y, z)
PARTITION BY d;

INSERT INTO pk_block_union (x, y, z);

SELECT
    cityHash64(1, x = 3
    AND y = 44, '0', 1, 1, 1, 1, 1, 1, 1, toLowCardinality(1), 1, 1, 1, 1, 1, toNullable(toUInt256(1)), 1, 1, 1, toUInt128(1), 1, toLowCardinality(toUInt128(1)), 1, 1),
    cityHash64('0', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, toUInt128(1), 1, 1, toLowCardinality(1), 1, 1, toLowCardinality(1), toLowCardinality(1), 1, 1, 1, 1, 1),
    *
FROM pk_block_union
WHERE x = 3
    AND y = 44
ORDER BY `ALL` DESC;