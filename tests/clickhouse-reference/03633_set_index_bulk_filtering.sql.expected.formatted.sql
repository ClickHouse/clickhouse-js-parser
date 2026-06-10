DROP TABLE IF EXISTS tbulk;

CREATE TABLE tbulk
(
    g UInt64,
    s Int32,
    k Int64,
    x UInt64,
    INDEX gset g TYPE set(0) GRANULARITY 100
)
ENGINE = MergeTree()
ORDER BY (x, k, s) AS
SELECT
    number % 3,
    1,
    4,
    number % 10
FROM numbers(1000000.);

SELECT count(x)
FROM tbulk
WHERE g = 1
    AND k = 1
SETTINGS secondary_indices_enable_bulk_filtering = '0';

SELECT count(x)
FROM tbulk
WHERE g = 1
    AND k = 1
SETTINGS secondary_indices_enable_bulk_filtering = '1';