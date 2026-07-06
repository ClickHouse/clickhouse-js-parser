CREATE TABLE tab
(
    x Nullable(UInt8)
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS allow_nullable_key = '1', index_granularity = '2';

INSERT INTO tab SELECT number
FROM numbers(4);

SET allow_suspicious_low_cardinality_types = '1';

SET max_rows_to_read = '2';

-- Prevent remote replicas from skipping index analysis in Parallel Replicas. Otherwise, they may return full ranges and trigger max_rows_to_read validation failures.
SET parallel_replicas_index_analysis_only_on_coordinator = '0';

SELECT x + 1
FROM tab
WHERE plus(x, 1) <= 2
ORDER BY x ASC;

SELECT x + 1
FROM tab
WHERE plus(x, CAST('1' AS Nullable(UInt8))) <= 2
ORDER BY x ASC;

SELECT x + 1
FROM tab
WHERE plus(x, CAST('1' AS LowCardinality(UInt8))) <= 2
ORDER BY x ASC;

SELECT x + 1
FROM tab
WHERE plus(x, CAST('1' AS LowCardinality(Nullable(UInt8)))) <= 2
ORDER BY x ASC;

SELECT 1 + x
FROM tab
WHERE plus(1, x) <= 2
ORDER BY x ASC;

SELECT 1 + x
FROM tab
WHERE plus(CAST('1' AS Nullable(UInt8)), x) <= 2
ORDER BY x ASC;

SELECT 1 + x
FROM tab
WHERE plus(CAST('1' AS LowCardinality(UInt8)), x) <= 2
ORDER BY x ASC;

SELECT 1 + x
FROM tab
WHERE plus(CAST('1' AS LowCardinality(Nullable(UInt8))), x) <= 2
ORDER BY x ASC;

DROP TABLE tab;

SET max_rows_to_read = '100';

CREATE TABLE tab
(
    x LowCardinality(UInt8)
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS allow_nullable_key = '1', index_granularity = '2';

CREATE TABLE tab
(
    x UInt128
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS allow_nullable_key = '1', index_granularity = '2';

SELECT x + 1
FROM tab
WHERE x + CAST('1' AS LowCardinality(UInt8)) <= -9223372036854775808
ORDER BY x ASC;

CREATE TABLE tab
(
    x DateTime
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS allow_nullable_key = '1', index_granularity = '2';

INSERT INTO tab SELECT toDateTime('2022-02-02') + number
FROM numbers(4);

SELECT x + 1
FROM tab
WHERE plus(x, 1) <= toDateTime('2022-02-02') + 2
ORDER BY x ASC;

SELECT x + 1
FROM tab
WHERE plus(x, CAST('1' AS Nullable(UInt8))) <= toDateTime('2022-02-02') + 2
ORDER BY x ASC;

SELECT x + 1
FROM tab
WHERE plus(x, CAST('1' AS LowCardinality(UInt8))) <= toDateTime('2022-02-02') + 2
ORDER BY x ASC;

SELECT x + 1
FROM tab
WHERE plus(x, CAST('1' AS LowCardinality(Nullable(UInt8)))) <= toDateTime('2022-02-02') + 2
ORDER BY x ASC;

SELECT 1 + x
FROM tab
WHERE plus(1, x) <= toDateTime('2022-02-02') + 2
ORDER BY x ASC;

SELECT 1 + x
FROM tab
WHERE plus(CAST('1' AS Nullable(UInt8)), x) <= toDateTime('2022-02-02') + 2
ORDER BY x ASC;

SELECT 1 + x
FROM tab
WHERE plus(CAST('1' AS LowCardinality(UInt8)), x) <= toDateTime('2022-02-02') + 2
ORDER BY x ASC;

SELECT 1 + x
FROM tab
WHERE plus(CAST('1' AS LowCardinality(Nullable(UInt8))), x) <= toDateTime('2022-02-02') + 2
ORDER BY x ASC;

SELECT x + 1
FROM tab
WHERE x + CAST('1' AS Nullable(UInt8)) <= -2147483647
ORDER BY x ASC NULLS FIRST;