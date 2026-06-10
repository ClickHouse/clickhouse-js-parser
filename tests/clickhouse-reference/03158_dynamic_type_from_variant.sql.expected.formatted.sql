SET allow_experimental_dynamic_type = '1';

SET allow_experimental_variant_type = '1';

SET allow_suspicious_types_in_order_by = '1';

CREATE TABLE test_variable
(
    v Variant(String, UInt32, IPv6, Bool, DateTime64)
)
ENGINE = Memory();

CREATE TABLE test_dynamic
(
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test_variable;

SELECT
    v,
    toTypeName(v)
FROM test_variable
ORDER BY v ASC;

INSERT INTO test_dynamic SELECT *
FROM test_variable;

SELECT
    d,
    dynamicType(d)
FROM test_dynamic
ORDER BY d ASC;