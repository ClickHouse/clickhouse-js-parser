SET optimize_trivial_insert_select = '1';

DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    i int,
    j int,
    k int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi', min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0', ratio_of_defaults_for_sparse_serialization = '1';

INSERT INTO x SELECT
    number,
    number * 2,
    number * 3
FROM numbers(100000);

-- One granule, (_part_offset (8 bytes) + <one minimal physical column> (4 bytes)) * 8192 + <other two physical columns>(8 bytes) * 1 = 98312
SELECT *
FROM x
PREWHERE _part_offset = 0
SETTINGS max_bytes_to_read = '98312';

DROP TABLE x;