-- Tags: no-random-merge-tree-settings
SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO t SELECT number
FROM numbers_mt(10000000)
SETTINGS max_insert_threads = '8';

SET allow_prefetched_read_pool_for_remote_filesystem = '0';

SET allow_prefetched_read_pool_for_local_filesystem = '0';

-- { echo }
-- The number of output streams is limited by max_streams_for_merge_tree_reading
SELECT sum(x)
FROM t
SETTINGS
    max_threads = '32',
    max_streams_for_merge_tree_reading = '16',
    allow_asynchronous_read_from_io_pool_for_merge_tree = '0';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT sum(x)
                FROM t
                SETTINGS
                    max_threads = '32',
                    max_streams_for_merge_tree_reading = '16',
                    allow_asynchronous_read_from_io_pool_for_merge_tree = '0'
            ))
    )
WHERE `explain` LIKE '%Resize%'
    OR `explain` LIKE '%MergeTreeSelect%';

-- Without asynchronous_read, max_streams_for_merge_tree_reading limits max_streams * max_streams_to_max_threads_ratio
SELECT sum(x)
FROM t
SETTINGS
    max_threads = '4',
    max_streams_for_merge_tree_reading = '16',
    allow_asynchronous_read_from_io_pool_for_merge_tree = '0',
    max_streams_to_max_threads_ratio = '8';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT sum(x)
                FROM t
                SETTINGS
                    max_threads = '4',
                    max_streams_for_merge_tree_reading = '16',
                    allow_asynchronous_read_from_io_pool_for_merge_tree = '0',
                    max_streams_to_max_threads_ratio = '8'
            ))
    )
WHERE `explain` LIKE '%Resize%'
    OR `explain` LIKE '%MergeTreeSelect%';

-- With asynchronous_read, read in max_streams_for_merge_tree_reading async streams and resize to max_threads
SELECT sum(x)
FROM t
SETTINGS
    max_threads = '4',
    max_streams_for_merge_tree_reading = '16',
    allow_asynchronous_read_from_io_pool_for_merge_tree = '1';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT sum(x)
                FROM t
                SETTINGS
                    max_threads = '4',
                    max_streams_for_merge_tree_reading = '16',
                    allow_asynchronous_read_from_io_pool_for_merge_tree = '1'
            ))
    )
WHERE `explain` LIKE '%Resize%'
    OR `explain` LIKE '%MergeTreeSelect%';

-- With asynchronous_read, read using max_streams * max_streams_to_max_threads_ratio async streams, resize to max_streams_for_merge_tree_reading outp[ut streams, resize to max_threads after aggregation
SELECT sum(x)
FROM t
SETTINGS
    max_threads = '4',
    max_streams_for_merge_tree_reading = '16',
    allow_asynchronous_read_from_io_pool_for_merge_tree = '1',
    max_streams_to_max_threads_ratio = '8';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT sum(x)
                FROM t
                SETTINGS
                    max_threads = '4',
                    max_streams_for_merge_tree_reading = '16',
                    allow_asynchronous_read_from_io_pool_for_merge_tree = '1',
                    max_streams_to_max_threads_ratio = '8'
            ))
    )
WHERE `explain` LIKE '%Resize%'
    OR `explain` LIKE '%MergeTreeSelect%';

-- For read-in-order, disable everything
SET query_plan_remove_redundant_sorting = '0'; -- to keep reading in order

SELECT sum(x)
FROM (
        SELECT x
        FROM t
        ORDER BY x ASC
    )
SETTINGS
    max_threads = '4',
    max_streams_for_merge_tree_reading = '16',
    allow_asynchronous_read_from_io_pool_for_merge_tree = '1',
    optimize_read_in_order = '1',
    query_plan_read_in_order = '1';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT sum(x)
                FROM (
                        SELECT x
                        FROM t
                        ORDER BY x ASC
                    )
                SETTINGS
                    max_threads = '4',
                    max_streams_for_merge_tree_reading = '16',
                    allow_asynchronous_read_from_io_pool_for_merge_tree = '1',
                    optimize_read_in_order = '1',
                    query_plan_read_in_order = '1'
            ))
    )
WHERE `explain` LIKE '%Resize%';

SELECT sum(x)
FROM (
        SELECT x
        FROM t
        ORDER BY x ASC
    )
SETTINGS
    max_threads = '4',
    max_streams_for_merge_tree_reading = '16',
    allow_asynchronous_read_from_io_pool_for_merge_tree = '1',
    max_streams_to_max_threads_ratio = '8',
    optimize_read_in_order = '1',
    query_plan_read_in_order = '1';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT sum(x)
                FROM (
                        SELECT x
                        FROM t
                        ORDER BY x ASC
                    )
                SETTINGS
                    max_threads = '4',
                    max_streams_for_merge_tree_reading = '16',
                    allow_asynchronous_read_from_io_pool_for_merge_tree = '1',
                    max_streams_to_max_threads_ratio = '8',
                    optimize_read_in_order = '1',
                    query_plan_read_in_order = '1'
            ))
    )
WHERE `explain` LIKE '%Resize%';

-- { echoOff }
DROP TABLE t;