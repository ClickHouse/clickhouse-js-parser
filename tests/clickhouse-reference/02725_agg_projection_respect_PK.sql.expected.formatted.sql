-- Tags: no-random-merge-tree-settings
-- add_minmax_index_for_numeric_columns=0: Would use the index and not the projection that we want to test (id2 = 3)
DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c1 Int64,
    c2 Int64,
    c3 Int64,
    PROJECTION p1 (SELECT c1, c2, sum(c3) GROUP BY c2, c1)
)
ENGINE = MergeTree()
ORDER BY (c1, c2)
SETTINGS min_bytes_for_wide_part = '10485760', min_rows_for_wide_part = '0', add_minmax_index_for_numeric_columns = '0';

SET optimize_trivial_insert_select = '1';

INSERT INTO t0 SELECT
    number,
    -number,
    number
FROM numbers_mt(100000.);

SET parallel_replicas_local_plan = '1', parallel_replicas_support_projection = '1', optimize_aggregation_in_order = '0';

SELECT trimLeft(*)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT
                    c1,
                    sum(c3)
                FROM t0
                GROUP BY c1
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%';

SELECT trimLeft(*)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT
                    c1,
                    sum(c3)
                FROM t0
                WHERE c1 = 100
                GROUP BY c1
            ))
    )
WHERE `explain` LIKE '%Granules%';

DROP TABLE t0;