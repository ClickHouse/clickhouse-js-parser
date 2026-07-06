DROP TABLE IF EXISTS qbits;

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(BFloat16, 16)
)
ENGINE = SummingMergeTree()
ORDER BY id;

-- The elements of qbits will not be summed and this is expected behavior
INSERT INTO qbits;

INSERT INTO qbits;

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
ENGINE = AggregatingMergeTree()
ORDER BY id;

CREATE TABLE qbits
(
    id UInt8,
    sign Int8,
    vec QBit(BFloat16, 16),
    `order` UInt8
)
ENGINE = CollapsingMergeTree(sign)
ORDER BY id;

INSERT INTO qbits;

INSERT INTO qbits;

INSERT INTO qbits;

SELECT *
FROM qbits
ORDER BY `order` ASC;

CREATE TABLE qbits
(
    id Int8,
    sign Int8,
    ver Int8,
    vec QBit(BFloat16, 16)
)
ENGINE = VersionedCollapsingMergeTree(sign, ver)
ORDER BY ver;

INSERT INTO qbits;

INSERT INTO qbits;

INSERT INTO qbits;