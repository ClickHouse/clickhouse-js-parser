-- Tests merge tree 'setting' materialize_skip_indexes_on_merge
-- add_minmax_index_for_numeric_columns=0: Different indices and plans on b
SET enable_analyzer = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    a UInt64,
    b UInt64,
    INDEX idx_a a TYPE minmax() GRANULARITY 1,
    INDEX idx_b b TYPE set(3) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '4', add_minmax_index_for_numeric_columns = '0';

INSERT INTO tab SELECT
    number,
    number / 50
FROM numbers(100);

INSERT INTO tab SELECT
    number,
    number / 50
FROM numbers(100, 100);

OPTIMIZE TABLE tab FINAL;

SELECT count()
FROM tab
WHERE a >= 110
    AND a < 130
    AND b = 2;

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE a >= 110
                    AND a < 130
                    AND b = 2
            ))
    )
WHERE `explain` LIKE '%Skip%'
    OR `explain` LIKE '%Name:%'
    OR `explain` LIKE '%Granules:%';

SELECT
    database,
    table,
    name,
    data_compressed_bytes
FROM `system`.data_skipping_indices
WHERE database = currentDatabase()
    AND table = 'tab';

ALTER TABLE tab MODIFY SETTING materialize_skip_indexes_on_merge = '0';

TRUNCATE TABLE tab;

SYSTEM FLUSH LOGS query_log;

SELECT
    count(),
    sum(ProfileEvents['MergeTreeDataWriterSkipIndicesCalculationMicroseconds'])
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND query LIKE 'OPTIMIZE TABLE tab FINAL'
    AND type = 'QueryFinish';

SET mutations_sync = '2';

ALTER TABLE tab MATERIALIZE INDEX idx_a;

ALTER TABLE tab MATERIALIZE INDEX idx_b;

ALTER TABLE tab RESET SETTING materialize_skip_indexes_on_merge;

DROP TABLE tab;