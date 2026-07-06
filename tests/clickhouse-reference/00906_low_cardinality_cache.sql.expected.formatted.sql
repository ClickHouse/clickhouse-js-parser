-- Tags: long
SET max_rows_to_read = '100M', max_execution_time = '600';

DROP TABLE IF EXISTS lc_00906;

CREATE TABLE lc_00906
(
    b LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY b
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi', vertical_merge_algorithm_min_rows_to_activate = '100000000';

INSERT INTO lc_00906 SELECT '0123456789'
FROM numbers(100000000)
SETTINGS
    max_insert_threads = '6',
    max_threads = '4';

SELECT
    count(),
    b
FROM lc_00906
GROUP BY b;