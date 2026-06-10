SET session_timezone = 'UTC';

-- toDate32 function
CREATE TABLE test_date32_casts
(
    `from` String,
    val Date32
)
ENGINE = Memory();

INSERT INTO test_date32_casts; -- BFloat16 can't represent 120530 exactly, but it's still the same date

SELECT
    `from`,
    val,
    val::Int32
FROM test_date32_casts
ORDER BY `ALL` ASC;

TRUNCATE TABLE test_date32_casts;

INSERT INTO test_date32_casts;

INSERT INTO test_date32_casts;

-- toDate function
CREATE TABLE test_date_casts
(
    `from` String,
    val Date
)
ENGINE = Memory();

INSERT INTO test_date_casts; -- BFloat16 can't represent 86400 exactly, but it's still the same date

SELECT
    `from`,
    val,
    val::UInt16
FROM test_date_casts
ORDER BY `ALL` ASC;

TRUNCATE TABLE test_date_casts;

INSERT INTO test_date_casts;

INSERT INTO test_date_casts;

CREATE TABLE fuzz_71531
(
    c0 Date32 DEFAULT -30000
)
ENGINE = Memory();

INSERT INTO fuzz_71531 (c0);

SELECT c0
FROM fuzz_71531
ORDER BY c0 ASC;

CREATE TABLE fuzz_86799
(
    c0 Date32
)
ENGINE = Memory();

INSERT INTO fuzz_86799 (c0);

SELECT c0
FROM fuzz_86799
ORDER BY c0 ASC;