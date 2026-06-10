DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    s Int128,
    v Variant(UUID, Int128)
)
ENGINE = MergeTree()
ORDER BY s
SETTINGS index_granularity = '2', index_granularity_bytes = '0', min_rows_for_wide_part = '0', min_bytes_for_wide_part = '0';

INSERT INTO test SELECT
    CAST('42' AS Int128),
    CAST('42' AS Int128);

SELECT v
FROM test
PREWHERE 1;

DROP TABLE test;