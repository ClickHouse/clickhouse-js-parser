SET allow_experimental_variant_type = '1';

CREATE TABLE test
(
    v Variant(UInt64, String, Array(UInt64))
)
ENGINE = Memory();

INSERT INTO test;

SELECT variantType(v) AS type
FROM test;

SELECT toTypeName(variantType(v))
FROM test
LIMIT 1;

SELECT variantType()
FROM test; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT variantType(v, v)
FROM test; -- {serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT variantType(v.String)
FROM test; -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT variantType(v::Variant(UInt64, String, Array(UInt64), Date)) AS type
FROM test;

SELECT toTypeName(variantType(v::Variant(UInt64, String, Array(UInt64), Date)))
FROM test
LIMIT 1;