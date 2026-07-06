DROP TABLE IF EXISTS qbits;

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(BFloat16, 16)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO qbits;

INSERT INTO qbits;

-- Check everything is correct after parts are merged
SELECT *
FROM qbits
ORDER BY id ASC;

OPTIMIZE TABLE qbits FINAL;

DROP TABLE qbits;

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(BFloat16, 16)
)
ENGINE = ReplacingMergeTree()
ORDER BY id;

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(BFloat16, 16)
)
ENGINE = CoalescingMergeTree()
ORDER BY id;