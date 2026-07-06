DROP TABLE IF EXISTS qbits;

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(Float64, 9)
)
ENGINE = Memory();

INSERT INTO qbits SELECT
    number + 1 AS id,
    arrayMap((i -> i + number), range(9)) AS vec
FROM numbers(9);

SELECT *
FROM qbits
ORDER BY id ASC;

DROP TABLE qbits;

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(Float32, 9)
)
ENGINE = Memory();

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(BFloat16, 9)
)
ENGINE = Memory();