SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS test_table_72265_1;

CREATE TABLE test_table_72265_1
(
    a LowCardinality(Nullable(Int64)),
    b UInt64
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a % 2
SETTINGS allow_nullable_key = '1', index_granularity = '64', index_granularity_bytes = '10M', min_bytes_for_wide_part = '0';

INSERT INTO test_table_72265_1 SELECT
    number,
    number
FROM numbers(10000);

SELECT count()
FROM test_table_72265_1
WHERE a > 100
    AND a % 2 = toUInt128(0);

DROP TABLE IF EXISTS test_table_72265_2;

CREATE TABLE test_table_72265_2
(
    part LowCardinality(Nullable(Int64))
)
ENGINE = MergeTree()
ORDER BY part
PARTITION BY part
SETTINGS allow_nullable_key = '1';

INSERT INTO test_table_72265_2 (part);

SELECT *
FROM test_table_72265_2
PREWHERE part = toUInt128(1);