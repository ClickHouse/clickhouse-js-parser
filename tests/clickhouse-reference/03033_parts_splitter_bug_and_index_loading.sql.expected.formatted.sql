CREATE TABLE t
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS index_granularity = '1';

SYSTEM STOP MERGES t;

-- for this part the first columns is useless, so we have to use both
INSERT INTO t SELECT
    42,
    number
FROM numbers_mt(100);

-- for this part the first columns is enough
INSERT INTO t SELECT
    number,
    number
FROM numbers_mt(100);

-- force reloading index
DETACH TABLE t;

ATTACH TABLE t;

SET merge_tree_min_bytes_for_concurrent_read = '1', merge_tree_min_rows_for_concurrent_read = '1', merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 1., max_threads = '4';

-- the bug happened when we used (a, b) index values for one part and only (a) for another in PartsSplitter. even a simple count query is enough,
-- because some granules were assinged to wrong layers and hence not returned from the reading step (because they were filtered out by `FilterSortedStreamByRange`)
SELECT count()
FROM t
WHERE NOT ignore(*);