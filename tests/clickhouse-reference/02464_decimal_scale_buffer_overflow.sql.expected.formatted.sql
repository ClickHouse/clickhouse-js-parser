DROP TABLE IF EXISTS series__fuzz_35;

CREATE TABLE series__fuzz_35
(
    i UInt8,
    x_value Decimal(18, 14),
    y_value DateTime
)
ENGINE = Memory();

INSERT INTO series__fuzz_35 (i, x_value, y_value);

SELECT skewSamp(x_value)
FROM (
        SELECT x_value AS x_value
        FROM series__fuzz_35
        LIMIT 2
    )
FORMAT Null;

DROP TABLE series__fuzz_35;