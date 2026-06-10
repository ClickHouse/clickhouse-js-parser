-- Tags: no-parallel
DROP TABLE IF EXISTS table_decimal_dict;

DROP DICTIONARY IF EXISTS decimal_dict;

CREATE TABLE table_decimal_dict
(
    KeyField UInt64,
    Decimal32_ Decimal(5, 4),
    Decimal64_ Decimal(18, 8),
    Decimal128_ Decimal(25, 8),
    Decimal256_ Decimal(76, 37)
)
ENGINE = Memory();

INSERT INTO table_decimal_dict SELECT
    number,
    number / 3,
    number / 3,
    number / 3,
    number / 3
FROM numbers(5000);

CREATE DICTIONARY IF NOT EXISTS decimal_dict
(
    KeyField UInt64 DEFAULT 9999999,
    Decimal32_ Decimal(5, 4) DEFAULT 0.11,
    Decimal64_ Decimal(18, 8) DEFAULT 0.11,
    Decimal128_ Decimal(25, 8) DEFAULT 0.11
)
PRIMARY KEY KeyField
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_decimal_dict' DB current_database()))
LIFETIME(MIN 0 MAX 0)
LAYOUT(SPARSE_HASHED());

SELECT '-------- 42 --------';

SELECT *
FROM table_decimal_dict
WHERE KeyField = 42;

SELECT *
FROM decimal_dict
WHERE KeyField = 42;

SELECT
    dictGet('decimal_dict', 'Decimal32_', toUInt64(42)),
    dictGet('decimal_dict', 'Decimal64_', toUInt64(42)),
    dictGet('decimal_dict', 'Decimal128_', toUInt64(42));

-- ,dictGet('decimal_dict', 'Decimal256_', toUInt64(42))
SELECT *
FROM table_decimal_dict
WHERE KeyField = 4999;

SELECT *
FROM decimal_dict
WHERE KeyField = 4999;

SELECT
    dictGet('decimal_dict', 'Decimal32_', toUInt64(4999)),
    dictGet('decimal_dict', 'Decimal64_', toUInt64(4999)),
    dictGet('decimal_dict', 'Decimal128_', toUInt64(4999));

--,dictGet('decimal_dict', 'Decimal256_', toUInt64(4999))
SELECT *
FROM table_decimal_dict
WHERE KeyField = 5000;

SELECT *
FROM decimal_dict
WHERE KeyField = 5000;

SELECT
    dictGet('decimal_dict', 'Decimal32_', toUInt64(5000)),
    dictGet('decimal_dict', 'Decimal64_', toUInt64(5000)),
    dictGet('decimal_dict', 'Decimal128_', toUInt64(5000)); --,dictGet('decimal_dict', 'Decimal256_', toUInt64(5000))