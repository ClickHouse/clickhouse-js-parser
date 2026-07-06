DROP TABLE IF EXISTS decimal_sum;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE decimal_sum
(
    date Date,
    sum32 Decimal32(4),
    sum64 Decimal64(8),
    sum128 Decimal128(10)
)
ENGINE = SummingMergeTree(date, date, 8192);

INSERT INTO decimal_sum;

INSERT INTO decimal_sum;

OPTIMIZE TABLE decimal_sum;

SELECT *
FROM decimal_sum;

INSERT INTO decimal_sum;

INSERT INTO decimal_sum;

DROP TABLE decimal_sum;