DROP TABLE IF EXISTS bloom_filter_sizing_pk;

CREATE TABLE bloom_filter_sizing_pk
(
    key UInt64,
    value UInt64,
    INDEX key_bf key TYPE bloom_filter(0.01) GRANULARITY 2147483648
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS add_minmax_index_for_numeric_columns = '0';

INSERT INTO bloom_filter_sizing_pk SELECT
    number % 100 AS key, -- 100 unique keys
    number AS value -- whatever
FROM numbers(100000);

--
-- Merge everything into a single part
--
OPTIMIZE TABLE bloom_filter_sizing_pk FINAL;

SELECT COUNT()
FROM bloom_filter_sizing_pk
WHERE key = 1;

-- Check bloom filter size. According to https://hur.st/bloomfilter/?n=100&p=0.01 for 100 keys it should be less that 200B
SELECT COUNT()
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'bloom_filter_sizing_pk'
    AND secondary_indices_uncompressed_bytes > 200
    AND active;

DROP TABLE IF EXISTS bloom_filter_sizing_sec;

CREATE TABLE bloom_filter_sizing_sec
(
    key1 UInt64,
    key2 UInt64,
    value UInt64,
    INDEX key_bf key2 TYPE bloom_filter(0.01) GRANULARITY 2147483648
)
ENGINE = MergeTree()
ORDER BY key1
SETTINGS add_minmax_index_for_numeric_columns = '0';

INSERT INTO bloom_filter_sizing_sec SELECT
    number % 100 AS key1, -- 100 unique keys
    rand() % 100 AS key2, -- 100 unique keys
    number AS value -- whatever
FROM numbers(100000);

--
-- Merge everything into a single part
--
OPTIMIZE TABLE bloom_filter_sizing_sec FINAL;

SELECT COUNT()
FROM bloom_filter_sizing_sec
WHERE key1 = 1;

-- Check bloom filter size. According to https://hur.st/bloomfilter/?n=100&p=0.01 for 100 keys it should be less that 200B
SELECT COUNT()
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'bloom_filter_sizing_sec'
    AND secondary_indices_uncompressed_bytes > 200
    AND active;