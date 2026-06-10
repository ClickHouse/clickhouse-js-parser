-- Tags: no-object-storage
SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

DROP TABLE IF EXISTS data_02233;

CREATE TABLE data_02233
(
    parent_key Int,
    child_key Int,
    value Int
)
ENGINE = MergeTree()
ORDER BY parent_key;

-- before inserting data, it may produce empty header
SELECT
    child_key,
    parent_key,
    child_key
FROM data_02233
GROUP BY
    parent_key,
    child_key,
    child_key
ORDER BY parent_key ASC NULLS LAST
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '1';

SELECT
    child_key,
    parent_key,
    child_key
FROM data_02233
GROUP BY
    parent_key,
    child_key,
    child_key
WITH TOTALS
ORDER BY parent_key ASC NULLS LAST
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '1';

-- { echoOn }
INSERT INTO data_02233 SELECT
    number % 10,
    number % 3,
    number
FROM numbers(100);

EXPLAIN PIPELINE
SELECT
    parent_key,
    child_key,
    count()
FROM data_02233
GROUP BY
    parent_key,
    child_key
WITH TOTALS
ORDER BY
    parent_key ASC,
    child_key ASC
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '1',
    read_in_order_two_level_merge_threshold = '1';

EXPLAIN PIPELINE
SELECT
    parent_key,
    child_key,
    count()
FROM data_02233
GROUP BY
    parent_key,
    child_key
WITH TOTALS
ORDER BY
    parent_key ASC,
    child_key ASC
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '0',
    read_in_order_two_level_merge_threshold = '1';

SELECT
    parent_key,
    child_key,
    count()
FROM data_02233
GROUP BY
    parent_key,
    child_key
WITH TOTALS
ORDER BY
    parent_key ASC,
    child_key ASC
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '1';

SELECT
    parent_key,
    child_key,
    count()
FROM data_02233
GROUP BY
    parent_key,
    child_key
WITH TOTALS
ORDER BY
    parent_key ASC,
    child_key ASC
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '1',
    max_block_size = '1';

SELECT
    parent_key,
    child_key,
    count()
FROM data_02233
GROUP BY
    parent_key,
    child_key
WITH TOTALS
ORDER BY
    parent_key ASC,
    child_key ASC
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '0';

-- fuzzer
SELECT
    child_key,
    parent_key,
    child_key
FROM data_02233
GROUP BY
    parent_key,
    child_key,
    child_key
ORDER BY
    child_key ASC,
    parent_key ASC NULLS LAST
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '1';

SELECT
    child_key,
    parent_key,
    child_key
FROM data_02233
GROUP BY
    parent_key,
    child_key,
    child_key
WITH TOTALS
ORDER BY
    child_key ASC,
    parent_key ASC NULLS LAST
SETTINGS
    max_threads = '1',
    optimize_aggregation_in_order = '1';

-- { echoOff }
DROP TABLE data_02233;