-- Tags: no-tsan, no-asan, no-ubsan, no-msan, no-debug
DROP TABLE IF EXISTS tab_lc;

CREATE TABLE tab_lc
(
    x UInt64,
    y LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO tab_lc SELECT
    number,
    toString(number % 10)
FROM numbers(20000000);

OPTIMIZE TABLE tab_lc;

SET max_rows_to_read = '21M';

SELECT count()
FROM tab_lc
WHERE y = '0'
SETTINGS local_filesystem_read_prefetch = '1';