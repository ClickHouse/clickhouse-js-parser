DROP TABLE IF EXISTS sample_merge_tree;

CREATE TABLE sample_merge_tree
(
    dt DateTime,
    x UInt64
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY toYYYYMMDD(dt)
SETTINGS min_merge_bytes_to_use_direct_io = '1', index_granularity = '8192';

INSERT INTO sample_merge_tree;

OPTIMIZE TABLE sample_merge_tree FINAL;

SELECT *
FROM sample_merge_tree
ORDER BY x ASC;