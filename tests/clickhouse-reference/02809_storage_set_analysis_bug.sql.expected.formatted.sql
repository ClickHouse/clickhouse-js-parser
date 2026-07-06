DROP TABLE IF EXISTS test_set;

DROP TABLE IF EXISTS null_in__fuzz_6;

SET allow_suspicious_low_cardinality_types = '1';

CREATE TABLE null_in__fuzz_6
(
    dt LowCardinality(UInt16),
    idx Int32,
    i Nullable(Int256),
    s Int32
)
ENGINE = MergeTree()
ORDER BY idx
PARTITION BY dt;

INSERT INTO null_in__fuzz_6 SELECT *
FROM generateRandom()
WHERE i IS NOT NULL
LIMIT 1;

SET transform_null_in = '0';

CREATE TABLE test_set
(
    i Nullable(int)
)
ENGINE = Set();

INSERT INTO test_set;

SELECT count() = 1
FROM null_in__fuzz_6
PREWHERE 71
WHERE i IN (test_set); -- { serverError CANNOT_CONVERT_TYPE }

DROP TABLE test_set;

DROP TABLE null_in__fuzz_6;