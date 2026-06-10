DROP TABLE IF EXISTS test_00861;

CREATE TABLE test_00861
(
    key UInt64,
    d32 Decimal32(2),
    d64 Decimal64(2),
    d128 Decimal128(2)
)
ENGINE = Memory();

INSERT INTO test_00861 FORMAT CSV;

DROP TABLE test_00861;