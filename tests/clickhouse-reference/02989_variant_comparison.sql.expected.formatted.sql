SET allow_experimental_variant_type = '1';

SET allow_suspicious_types_in_order_by = '1';

SET use_variant_default_implementation_for_comparisons = '0';

CREATE TABLE test
(
    v1 Variant(String, UInt64, Array(UInt32)),
    v2 Variant(String, UInt64, Array(UInt32))
)
ENGINE = Memory();

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

SELECT v1
FROM test
ORDER BY v1 ASC NULLS FIRST;

SELECT v1
FROM test
ORDER BY v1 ASC NULLS LAST;

SELECT v2
FROM test
ORDER BY v2 ASC NULLS FIRST;

SELECT v2
FROM test
ORDER BY v2 ASC NULLS LAST;

SELECT *
FROM test
ORDER BY
    v1 ASC,
    v2 ASC NULLS FIRST;

SELECT *
FROM test
ORDER BY
    v1 ASC,
    v2 ASC NULLS LAST;

SELECT *
FROM test
ORDER BY
    v2 ASC,
    v1 ASC NULLS FIRST;

SELECT *
FROM test
ORDER BY
    v2 ASC,
    v1 ASC NULLS LAST;

SELECT
    v1,
    v2,
    v1 = v2
FROM test
ORDER BY
    v1 ASC,
    v2 ASC;

SELECT
    v1,
    v2,
    v1 < v2
FROM test
ORDER BY
    v1 ASC,
    v2 ASC;

SELECT
    v1,
    v2,
    v1 <= v2
FROM test
ORDER BY
    v1 ASC,
    v2 ASC;

SELECT
    v1,
    v2,
    v1 > v2
FROM test
ORDER BY
    v1 ASC,
    v2 ASC;

SELECT
    v1,
    v2,
    v2 >= v2
FROM test
ORDER BY
    v1 ASC,
    v2 ASC;

DROP TABLE test;