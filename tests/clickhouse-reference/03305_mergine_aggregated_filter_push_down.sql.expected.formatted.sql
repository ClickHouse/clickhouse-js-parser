-- Tags: no-random-merge-tree-settings
-- add_minmax_index_for_numeric_columns=0: Different plan (would use the index on x)
CREATE TABLE tab
(
    x UInt32,
    y UInt32,
    z UInt32
)
ENGINE = MergeTree()
ORDER BY x
SETTINGS min_rows_for_wide_part = '0', min_bytes_for_wide_part = '0', add_minmax_index_for_numeric_columns = '0';

INSERT INTO tab SELECT
    number,
    number,
    number
FROM numbers(8129 * 123);

SET enable_analyzer = '1';

SET prefer_localhost_replica = '1';

SET optimize_aggregation_in_order = '0', optimize_read_in_order = '0';

-- { echoOn }
SELECT *
FROM (
        SELECT
            x,
            sum(y)
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab)
        GROUP BY x
    )
WHERE x = 42;

EXPLAIN indexes = '1'
SELECT *
FROM (
        SELECT
            x,
            sum(y)
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab)
        GROUP BY x
    )
WHERE x = 42;

SELECT *
FROM (
        SELECT
            x,
            sum(y)
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab)
        GROUP BY GROUPING SETS ((x, z + 1), (x, z + 2))
    )
WHERE x = 42;

EXPLAIN indexes = '1'
SELECT *
FROM (
        SELECT
            x,
            sum(y)
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab)
        GROUP BY GROUPING SETS ((x, z + 1), (x, z + 2))
    )
WHERE x = 42;

SELECT *
FROM (
        SELECT
            x,
            sum(y),
            z + 1 AS q
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab)
        GROUP BY GROUPING SETS ((x, z + 1), (x, z + 2))
    )
WHERE q = 42;

EXPLAIN indexes = '1'
SELECT *
FROM (
        SELECT
            x,
            sum(y),
            z + 1 AS q
        FROM remote('127.0.0.{1,2}', currentDatabase(), tab)
        GROUP BY GROUPING SETS ((x, z + 1), (x, z + 2))
    )
WHERE q = 42;

SET group_by_use_nulls = '1';