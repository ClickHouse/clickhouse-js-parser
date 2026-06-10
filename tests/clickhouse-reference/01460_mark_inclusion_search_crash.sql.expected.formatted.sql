DROP TABLE IF EXISTS pk;

CREATE TABLE pk
(
    d Date DEFAULT '2000-01-01',
    x DateTime,
    y UInt64,
    z UInt64
)
ENGINE = MergeTree()
ORDER BY (toStartOfMinute(x), y, z)
PARTITION BY d
SETTINGS index_granularity_bytes = '19', min_index_granularity_bytes = '1', write_final_mark = '0'; -- one row granule

INSERT INTO pk (x, y, z);

SET max_block_size = '1';

SET max_rows_to_read = '5';

-- Prevent remote replicas from skipping index analysis in Parallel Replicas. Otherwise, they may return full ranges and trigger max_rows_to_read validation failures.
SET parallel_replicas_index_analysis_only_on_coordinator = '0';

SELECT
    toUInt32(x),
    y,
    z
FROM pk
WHERE x >= toDateTime(100000)
    AND x <= toDateTime(90000);