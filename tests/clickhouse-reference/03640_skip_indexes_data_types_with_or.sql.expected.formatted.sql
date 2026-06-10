-- Tags: no-parallel-replicas
-- no-parallel-replicas: funny EXPLAIN PLAN output
-- add_minmax_index_for_numeric_columns=0: Different plan
-- Test that the skip indexes are utilized for AND and OR connected filter conditions
-- This test uses all the skip index types - minmax, set, bloom filter, text
-- Settings needed to achieve stable EXPLAIN PLAN output
SET parallel_replicas_local_plan = '1';

SET use_query_condition_cache = '0';

SET use_skip_indexes_on_data_read = '0';

SET use_skip_indexes = '1';

SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    i Int32,
    s String,
    u UInt32,
    t1 String,
    t2 String,
    INDEX minmax_index i TYPE minmax() GRANULARITY 1,
    INDEX set_index s TYPE set(10) GRANULARITY 1,
    INDEX bf_index u TYPE bloom_filter(0.001) GRANULARITY 1,
    INDEX text_index1 t1 TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX text_index2 t2 TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '6', index_granularity_bytes = '0', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0', max_bytes_to_merge_at_max_space_in_pool = '1', use_const_adaptive_granularity = '1', add_minmax_index_for_numeric_columns = '0';

-- 600 rows, 100 granules
INSERT INTO tab SELECT
    number,
    number,
    IF(number < 6, 'firststring', IF(number < 588, 'middlestring', 'laststring')),
    number,
    concat('This is text in row number', toString(number)),
    concat('Some thing for line', toString(number))
FROM numbers(600);

SET use_skip_indexes_for_disjunctions = '0';

SELECT '-- Simple OR condition'; -- surviving granules: 100, but only 1 granule is real match

SELECT `explain` AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE i = 1
                    OR s = 'firststring'
                    OR u = 1
                    OR hasToken(t1, 'number1')
            ))
    )
WHERE `explain` LIKE '%Granules%'
    OR `explain` LIKE '%PrimaryKey%'
    OR `explain` LIKE '%Name%';

SELECT `explain` AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE id >= 301
                    AND (i = 1
                    OR s = 'firststring'
                    OR u = 1
                    OR hasToken(t1, 'number1'))
            ))
    )
WHERE `explain` LIKE '%Granules%'
    OR `explain` LIKE '%PrimaryKey%'
    OR `explain` LIKE '%Name%';

SET use_skip_indexes_for_disjunctions = '1';

SELECT `explain` AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE i = 10
                    OR s = 'laststring'
            ))
    )
WHERE `explain` LIKE '%Granules%'
    OR `explain` LIKE '%PrimaryKey%'
    OR `explain` LIKE '%Name%';

SELECT `explain` AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE hasToken(t1, 'number1')
                    OR hasToken(t2, 'line1')
            ))
    )
WHERE `explain` LIKE '%Granules%'
    OR `explain` LIKE '%PrimaryKey%'
    OR `explain` LIKE '%Name%';

SELECT `explain` AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab
                WHERE hasToken(t1, 'number1')
                    OR hasToken(t2, 'line85')
            ))
    )
WHERE `explain` LIKE '%Granules%'
    OR `explain` LIKE '%PrimaryKey%'
    OR `explain` LIKE '%Name%';