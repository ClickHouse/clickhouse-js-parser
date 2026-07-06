-- Tags: no-parallel-replicas
-- Variant with incompatible types now throws on comparison (strict behavior)
SET allow_experimental_variant_type = '1';

SET allow_suspicious_variant_types = '1';

CREATE TABLE test
(
    v Variant(String, UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test;

-- These now throw errors because Variant(String, UInt64) has incompatible types
SELECT *
FROM test
WHERE v = 'Hello'; -- {serverError TYPE_MISMATCH}

SELECT *
FROM test
WHERE v = 42; -- {serverError NO_COMMON_TYPE}

SELECT *
FROM test
WHERE v = CAST('42' AS UInt64)::Variant(String, UInt64); -- {serverError NO_COMMON_TYPE}

DROP TABLE test;

-- Test with compatible types works fine
CREATE TABLE test_compat
(
    v Variant(UInt64, UInt32)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_compat;

SELECT *
FROM test_compat
WHERE v = 42;

SELECT *
FROM test_compat
WHERE v = 10;

DROP TABLE test_compat;