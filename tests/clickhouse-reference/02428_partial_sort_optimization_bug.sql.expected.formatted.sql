CREATE TABLE partial_sort_opt_bug
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1000';

INSERT INTO partial_sort_opt_bug SELECT number + 100000
FROM numbers(4000);

INSERT INTO partial_sort_opt_bug SELECT number
FROM numbers(1000);

INSERT INTO partial_sort_opt_bug SELECT number + 200000
FROM numbers(3000);

INSERT INTO partial_sort_opt_bug SELECT number + 1000
FROM numbers(4000);

OPTIMIZE TABLE partial_sort_opt_bug FINAL;

SELECT x
FROM partial_sort_opt_bug
ORDER BY x ASC
LIMIT 2000
SETTINGS max_block_size = '4000';