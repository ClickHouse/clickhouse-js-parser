-- Tags: no-fasttest, no-parallel
SET engine_file_truncate_on_insert = '1';

SET output_format_parquet_use_custom_encoder = '1';

SET output_format_parquet_row_group_size = '100';

SET input_format_parquet_filter_push_down = '0';

SET input_format_parquet_page_filter_push_down = '0';

SET input_format_parquet_bloom_filter_push_down = '1';

SET schema_inference_make_columns_nullable = 'auto';

SET enable_analyzer = '1'; -- required for multiple array joins

SET max_block_size = '1000000'; -- have only one block to make sure rows are split into row groups deterministically

SET preferred_block_size_bytes = '1000000000000';

CREATE TABLE data
(
    n UInt64,
    s String,
    l UInt256,
    d Decimal128(4),
    lc LowCardinality(String)
)
ENGINE = Memory();

INSERT INTO data SELECT
    number * 100,
    toString(number * 10),
    number * CAST('10000000000000000000000000000000000000000' AS UInt256),
    number * CAST('123.456' AS Decimal128(4)),
    'lc' || intDiv(number, 123) * 2
FROM numbers(1000);

-- Baseline test without bloom filter.
INSERT INTO FUNCTION file(bf_03263.parquet) SELECT *
FROM data
SETTINGS output_format_parquet_write_bloom_filter = '0';

SELECT
    'no bf: metadata',
    rg.num_rows,
    col.name,
    col.bloom_filter_bytes
FROM
    file(bf_03263.parquet, ParquetMetadata)
ARRAY JOIN row_groups AS rg
ARRAY JOIN rg.`columns` AS col
ORDER BY
    rg.file_offset ASC,
    col.name ASC;

SELECT
    'no bf: UInt64 hit',
    count(),
    sum(n = 12300 AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

SELECT
    'no bf: UInt64 miss',
    count(),
    sum(n = 12345 AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

-- With bloom filter.
INSERT INTO FUNCTION file(bf_03263.parquet) SELECT *
FROM data
SETTINGS output_format_parquet_write_bloom_filter = '1';

SELECT
    'bf: metadata',
    rg.num_rows,
    col.name,
    col.bloom_filter_bytes
FROM
    file(bf_03263.parquet, ParquetMetadata)
ARRAY JOIN row_groups AS rg
ARRAY JOIN rg.`columns` AS col
ORDER BY
    rg.file_offset ASC,
    col.name ASC;

SELECT
    'bf: UInt64 hit',
    count(),
    sum(n = 12300 AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

SELECT
    'bf: UInt64 miss',
    count(),
    sum(n = 12345 AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

SELECT
    'bf: String hit',
    count(),
    sum(s = '1230' AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

SELECT
    'bf: String miss',
    count(),
    sum(s = '1234' AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

SELECT
    'bf: UInt256 hit',
    count(),
    sum(l = CAST('7890000000000000000000000000000000000000000' AS UInt256) AS cond)
FROM file(bf_03263.parquet, Parquet, 'l UInt256')
WHERE indexHint(cond);

SELECT
    'bf: UInt256 miss',
    count(),
    sum(l = CAST('7890000000000000000000000000000000000000001' AS UInt256) AS cond)
FROM file(bf_03263.parquet, Parquet, 'l UInt256')
WHERE indexHint(cond);

SELECT
    'bf: Decimal128(4) hit',
    count(),
    sum(d = CAST('108147.456' AS Decimal128(4)) AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

SELECT
    'bf: Decimal128(4) miss',
    count(),
    sum(d = CAST('108147.4567' AS Decimal128(4)) AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

SELECT
    'bf: LowCardinality(String) hit',
    count(),
    sum(lc = 'lc4' AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

SELECT
    'bf: LowCardinality(String) miss',
    count(),
    sum(lc = 'lc1' AS cond)
FROM file(bf_03263.parquet)
WHERE indexHint(cond);

-- Try different output_format_parquet_bloom_filter_bits_per_value, check that size changed.
INSERT INTO FUNCTION file(bf_03263.parquet) SELECT *
FROM data
SETTINGS
    output_format_parquet_write_bloom_filter = '1',
    output_format_parquet_bloom_filter_bits_per_value = '30';

SELECT
    'more bits per value: metadata',
    rg.num_rows,
    col.name,
    col.bloom_filter_bytes
FROM
    file(bf_03263.parquet, ParquetMetadata)
ARRAY JOIN row_groups AS rg
ARRAY JOIN rg.`columns` AS col
ORDER BY
    rg.file_offset ASC,
    col.name ASC;