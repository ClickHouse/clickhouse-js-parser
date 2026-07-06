-- Tags: long, no-object-storage, no-msan
SET merge_tree_read_split_ranges_into_intersecting_and_non_intersecting_injection_probability = 0.;

SET max_threads = '16';

SET allow_aggregate_partitions_independently = '1';

SET force_aggregate_partitions_independently = '1';

SET optimize_use_projections = '0';

SET optimize_trivial_insert_select = '1';

SET allow_prefetched_read_pool_for_remote_filesystem = '0';

SET allow_prefetched_read_pool_for_local_filesystem = '0';

CREATE TABLE t1
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY a % 4
SETTINGS index_granularity = '8192', index_granularity_bytes = '10485760';

SYSTEM STOP MERGES t1;

INSERT INTO t1 SELECT number
FROM numbers_mt(1000000.);

-- { echoOn }
EXPLAIN PIPELINE
SELECT a
FROM t1
GROUP BY a;

-- { echoOff }
SELECT count()
FROM (
        SELECT throwIf(count() != 2)
        FROM t1
        GROUP BY a
    );

DROP TABLE t1;

CREATE TABLE t2
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY a % 8
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SYSTEM STOP MERGES t2;

INSERT INTO t2 SELECT number
FROM numbers_mt(1000000.);

-- { echoOn }
EXPLAIN PIPELINE
SELECT a
FROM t2
GROUP BY a;

-- { echoOff }
SELECT count()
FROM (
        SELECT throwIf(count() != 2)
        FROM t2
        GROUP BY a
    );

DROP TABLE t2;

CREATE TABLE t3
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY a % 16
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SYSTEM STOP MERGES t3;

INSERT INTO t3 SELECT number
FROM numbers_mt(1000000.);

-- { echoOn }
EXPLAIN PIPELINE
SELECT a
FROM t3
GROUP BY a;

-- { echoOff }
SELECT count()
FROM (
        SELECT throwIf(count() != 2)
        FROM t3
        GROUP BY a
    );

SELECT throwIf(count() != 4)
FROM remote('127.0.0.{1,2}', currentDatabase(), t3)
GROUP BY a
FORMAT Null;

-- if we happened to switch to external aggregation at some point, merging will happen as usual
SELECT count()
FROM (
        SELECT throwIf(count() != 2)
        FROM t3
        GROUP BY a
    )
SETTINGS
    max_bytes_before_external_group_by = '1Ki',
    max_bytes_ratio_before_external_group_by = '0';

DROP TABLE t3;

-- aggregation in order --
SET optimize_aggregation_in_order = '1';

CREATE TABLE t4
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a % 4
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SYSTEM STOP MERGES t4;

INSERT INTO t4 SELECT number
FROM numbers_mt(1000000.);

-- { echoOn }
EXPLAIN PIPELINE
SELECT a
FROM t4
GROUP BY a
SETTINGS read_in_order_two_level_merge_threshold = 1000000000000.;

-- { echoOff }
SELECT count()
FROM (
        SELECT throwIf(count() != 2)
        FROM t4
        GROUP BY a
    );

DROP TABLE t4;

CREATE TABLE t5
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a % 8
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SYSTEM STOP MERGES t5;

INSERT INTO t5 SELECT number
FROM numbers_mt(1000000.);

-- { echoOn }
EXPLAIN PIPELINE
SELECT a
FROM t5
GROUP BY a
SETTINGS read_in_order_two_level_merge_threshold = 1000000000000.;

-- { echoOff }
SELECT count()
FROM (
        SELECT throwIf(count() != 2)
        FROM t5
        GROUP BY a
    );

DROP TABLE t5;

CREATE TABLE t6
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a % 16
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SYSTEM STOP MERGES t6;

INSERT INTO t6 SELECT number
FROM numbers_mt(1000000.);

-- { echoOn }
EXPLAIN PIPELINE
SELECT a
FROM t6
GROUP BY a
SETTINGS read_in_order_two_level_merge_threshold = 1000000000000.;

-- { echoOff }
SELECT count()
FROM (
        SELECT throwIf(count() != 2)
        FROM t6
        GROUP BY a
    );

DROP TABLE t6;

SET optimize_aggregation_in_order = '0';

CREATE TABLE t7
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY intDiv(a, 2)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t7 SELECT number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT intDiv(a, 2) AS a1
                FROM t7
                GROUP BY a1
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t7;

CREATE TABLE t8
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY intDiv(a, 2) * 2 + 1
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t8 SELECT number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT intDiv(a, 2) + 1 AS a1
                FROM t8
                GROUP BY a1
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t8;

CREATE TABLE t9
(
    a UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY intDiv(a, 2)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t9 SELECT number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT intDiv(a, 3) AS a1
                FROM t9
                GROUP BY a1
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t9;

CREATE TABLE t10
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY (intDiv(a, 2), intDiv(b, 3))
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t10 SELECT
    number,
    number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    intDiv(a, 2) + 1 AS a1,
                    intDiv(b, 3) AS b1
                FROM t10
                GROUP BY
                    a1,
                    b1,
                    pi()
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t10;

-- multiplication by 2 is not injective, so optimization is not applicable
CREATE TABLE t11
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY (intDiv(a, 2), intDiv(b, 3))
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t11 SELECT
    number,
    number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    intDiv(a, 2) + 1 AS a1,
                    intDiv(b, 3) * 2 AS b1
                FROM t11
                GROUP BY
                    a1,
                    b1,
                    pi()
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t11;

CREATE TABLE t12
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a % 16;

INSERT INTO t12 SELECT
    number,
    number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    a,
                    b
                FROM t12
                GROUP BY
                    a,
                    b,
                    pi()
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t12;

CREATE TABLE t13
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY (intDiv(a, 2), intDiv(b, 3))
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t13 SELECT
    number,
    number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT s
                FROM t13
                GROUP BY
                    intDiv(a, 2) + intDiv(b, 3) AS s,
                    pi()
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t13;

CREATE TABLE t14
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY intDiv(a, 2) + intDiv(b, 3)
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t14 SELECT
    number,
    number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT
                    intDiv(a, 2) AS a1,
                    intDiv(b, 3) AS b1
                FROM t14
                GROUP BY
                    a1,
                    b1,
                    pi()
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t14;

-- to few partitions --
CREATE TABLE t15
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a < 90
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t15 SELECT
    number,
    number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT a
                FROM t15
                GROUP BY a
            ))
    )
WHERE `explain` LIKE '%Skip merging: %'
SETTINGS force_aggregate_partitions_independently = '0';

DROP TABLE t15;

-- to many partitions --
CREATE TABLE t16
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a % 16
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t16 SELECT
    number,
    number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT a
                FROM t16
                GROUP BY a
            ))
    )
WHERE `explain` LIKE '%Skip merging: %'
SETTINGS
    force_aggregate_partitions_independently = '0',
    max_number_of_partitions_for_independent_aggregation = '4';

DROP TABLE t16;

-- to big skew --
CREATE TABLE t17
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a < 90
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t17 SELECT
    number,
    number
FROM numbers_mt(100);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT a
                FROM t17
                GROUP BY a
            ))
    )
WHERE `explain` LIKE '%Skip merging: %'
SETTINGS
    force_aggregate_partitions_independently = '0',
    max_threads = '4';

DROP TABLE t17;

CREATE TABLE t18
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t18 SELECT
    number,
    number
FROM numbers_mt(50);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT a1
                FROM t18
                GROUP BY intDiv(a, 2) AS a1
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t18;

CREATE TABLE t19
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t19 SELECT
    number,
    number
FROM numbers_mt(50);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT a1
                FROM t19
                GROUP BY blockNumber() AS a1
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t19;

CREATE TABLE t20
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t20 SELECT
    number,
    number
FROM numbers_mt(50);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT a1
                FROM t20
                GROUP BY rand(a) AS a1
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t20;

CREATE TABLE t21
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a % 16
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t21 SELECT
    number,
    number
FROM numbers_mt(1000000.);

SELECT a
FROM t21
GROUP BY a
LIMIT 10
FORMAT Null;

DROP TABLE t21;

CREATE TABLE t22
(
    a UInt32,
    b UInt32
)
ENGINE = SummingMergeTree()
ORDER BY a
PARTITION BY a % 16
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t22 SELECT
    number,
    number
FROM numbers_mt(1000000.);

SELECT replaceRegexpOne(`explain`, '^[ ]*(.*)', '\\1')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT a
                FROM t22 FINAL
                GROUP BY a
            ))
    )
WHERE `explain` LIKE '%Skip merging: %';

DROP TABLE t22;