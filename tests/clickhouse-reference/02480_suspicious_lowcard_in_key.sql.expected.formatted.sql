SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    val LowCardinality(Float32)
)
ENGINE = MergeTree()
ORDER BY val;

INSERT INTO test;

SELECT count()
FROM test
WHERE toUInt64(val) = -1; -- { serverError CANNOT_CONVERT_TYPE }