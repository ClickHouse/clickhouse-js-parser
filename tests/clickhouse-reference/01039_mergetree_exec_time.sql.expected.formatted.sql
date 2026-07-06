DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    A Int64
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0';

INSERT INTO tab SELECT cityHash64(number)
FROM numbers(1000);

SELECT sum(sleep(0.1))
FROM tab
SETTINGS
    max_block_size = '1',
    max_execution_time = '1'; -- { serverError TIMEOUT_EXCEEDED }