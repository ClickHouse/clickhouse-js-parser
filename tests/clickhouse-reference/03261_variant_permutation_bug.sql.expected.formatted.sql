SET allow_experimental_variant_type = '1';

CREATE TABLE test
(
    x UInt64,
    d Variant(UInt64)
)
ENGINE = Memory();

INSERT INTO test SELECT
    number,
    NULL
FROM numbers(200000);

SELECT d
FROM test
ORDER BY d::String ASC
LIMIT 32213
FORMAT Null;

DROP TABLE test;