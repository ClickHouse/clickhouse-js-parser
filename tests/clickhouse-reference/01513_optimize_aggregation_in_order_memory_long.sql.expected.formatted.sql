-- Tags: long, no-random-merge-tree-settings
--- FIXME no-random-merge-tree-settings requires investigation
DROP TABLE IF EXISTS data_01513;

CREATE TABLE data_01513
(
    key String
)
ENGINE = MergeTree()
ORDER BY key;

-- 10e3 groups, 1e3 keys each
INSERT INTO data_01513 SELECT number % 10000.
FROM numbers(2000000.);

-- reduce number of parts to 1
OPTIMIZE TABLE data_01513 FINAL;

-- this is enough to trigger non-reusable Chunk in Arena.
SET max_memory_usage = '500M';

SET max_threads = '1';

SET max_block_size = '500';

SET max_bytes_before_external_group_by = '0';

SET max_bytes_ratio_before_external_group_by = '0';

SELECT
    key,
    groupArray(repeat('a', 200)),
    count()
FROM data_01513
GROUP BY key
FORMAT Null
SETTINGS optimize_aggregation_in_order = '0'; -- { serverError MEMORY_LIMIT_EXCEEDED }

SELECT
    key,
    groupArray(repeat('a', 200)),
    count()
FROM data_01513
GROUP BY key
FORMAT Null
SETTINGS optimize_aggregation_in_order = '1';

-- for WITH TOTALS previous groups should be kept.
SELECT
    key,
    groupArray(repeat('a', 200)),
    count()
FROM data_01513
GROUP BY key
WITH TOTALS
FORMAT Null
SETTINGS optimize_aggregation_in_order = '1'; -- { serverError MEMORY_LIMIT_EXCEEDED }

DROP TABLE data_01513;