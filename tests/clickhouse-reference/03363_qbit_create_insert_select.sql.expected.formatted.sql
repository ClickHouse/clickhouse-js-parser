DROP TABLE IF EXISTS qbits_16;

CREATE TABLE qbits_16
(
    id UInt32,
    vec QBit(BFloat16, 16)
)
ENGINE = Memory();

INSERT INTO qbits_16;

INSERT INTO qbits_16;

INSERT INTO qbits_16 (id);

INSERT INTO qbits_16; -- { error SIZES_OF_ARRAYS_DONT_MATCH }

SELECT *
FROM qbits_16
ORDER BY id ASC;

DROP TABLE qbits_16;

DROP TABLE IF EXISTS qbits_32;

CREATE TABLE qbits_32
(
    id UInt32,
    vec QBit(Float32, 16)
)
ENGINE = Memory();

INSERT INTO qbits_32;

INSERT INTO qbits_32;

INSERT INTO qbits_32 (id);

INSERT INTO qbits_32; -- { error SIZES_OF_ARRAYS_DONT_MATCH }

SELECT *
FROM qbits_32
ORDER BY id ASC;

DROP TABLE qbits_32;

DROP TABLE IF EXISTS qbits_64;

CREATE TABLE qbits_64
(
    id UInt32,
    vec QBit(Float64, 16)
)
ENGINE = Memory();

INSERT INTO qbits_64;

INSERT INTO qbits_64;

INSERT INTO qbits_64 (id);

INSERT INTO qbits_64; -- { error SIZES_OF_ARRAYS_DONT_MATCH }

SELECT *
FROM qbits_64
ORDER BY id ASC;

DROP TABLE qbits_64;

CREATE TABLE qbits_16
(
    id UInt32,
    vec QBit(BFloat16, 9)
)
ENGINE = Memory();

INSERT INTO qbits_16;

INSERT INTO qbits_16;

INSERT INTO qbits_16; -- { error SIZES_OF_ARRAYS_DONT_MATCH }

CREATE TABLE qbits_32
(
    id UInt32,
    vec QBit(Float32, 9)
)
ENGINE = Memory();

INSERT INTO qbits_32;

INSERT INTO qbits_32;

INSERT INTO qbits_32; -- { error SIZES_OF_ARRAYS_DONT_MATCH }

CREATE TABLE qbits_64
(
    id UInt32,
    vec QBit(Float64, 9)
)
ENGINE = Memory();

INSERT INTO qbits_64;

INSERT INTO qbits_64;

INSERT INTO qbits_64; -- { error SIZES_OF_ARRAYS_DONT_MATCH }

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(BFloat16, 1)
)
ENGINE = Memory();

INSERT INTO qbits;

SELECT *
FROM qbits;

DROP TABLE qbits;

CREATE TABLE qbits
(
    id UInt32,
    vec QBit(Float64, 1)
)
ENGINE = Memory();

INSERT INTO qbits;

DROP TABLE IF EXISTS array_64;

DROP TABLE IF EXISTS array_32;

DROP TABLE IF EXISTS array_16;

DROP TABLE IF EXISTS qbit_64;

DROP TABLE IF EXISTS qbit_32;

DROP TABLE IF EXISTS qbit_16;

CREATE TABLE array_64
(
    id UInt32,
    vec Array(Float64)
)
ENGINE = Memory();

CREATE TABLE array_32
(
    id UInt32,
    vec Array(Float32)
)
ENGINE = Memory();

CREATE TABLE array_16
(
    id UInt32,
    vec Array(BFloat16)
)
ENGINE = Memory();

INSERT INTO array_64;

INSERT INTO array_32 SELECT
    id,
    vec
FROM array_64
WHERE id = 1;

INSERT INTO array_16 SELECT
    id,
    vec
FROM array_64
WHERE id = 1;

CREATE TABLE qbit_64
(
    id UInt32,
    vec QBit(Float64, 28)
)
ENGINE = Memory();

CREATE TABLE qbit_32
(
    id UInt32,
    vec QBit(Float32, 28)
)
ENGINE = Memory();

CREATE TABLE qbit_16
(
    id UInt32,
    vec QBit(BFloat16, 28)
)
ENGINE = Memory();

INSERT INTO qbit_64 SELECT
    id,
    CAST(vec AS QBit(Float64, 28))
FROM array_64;

INSERT INTO qbit_32 SELECT
    id,
    CAST(vec AS QBit(Float32, 28))
FROM array_32;

INSERT INTO qbit_16 SELECT
    id,
    CAST(vec AS QBit(BFloat16, 28))
FROM array_16;

SELECT *
FROM qbit_64
ORDER BY id ASC;

SELECT *
FROM qbit_32
ORDER BY id ASC;

SELECT *
FROM qbit_16
ORDER BY id ASC;

DROP TABLE array_64;

DROP TABLE array_32;

DROP TABLE array_16;

DROP TABLE qbit_64;

DROP TABLE qbit_32;

DROP TABLE qbit_16;