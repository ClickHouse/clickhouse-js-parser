-- Tags: no-fasttest, no-ordinary-database, no-asan
-- no-asan: runs too long
-- Basic tests for text index stored in compact vs. wide format, respectively full vs. packed parts
SET enable_full_text_index = '1';

SET parallel_replicas_local_plan = '1'; -- this setting is randomized, set it explicitly to have local plan for parallel replicas

DROP TABLE IF EXISTS tab_compact_full;

DROP TABLE IF EXISTS tab_wide_full;

CREATE TABLE tab_compact_full
(
    id Int32,
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = 1000000000., min_rows_for_wide_part = 1000000000., min_bytes_for_full_part_storage = '0', index_granularity = '3';

CREATE TABLE tab_wide_full
(
    id Int32,
    str String,
    INDEX idx str TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0', min_bytes_for_full_part_storage = '0', index_granularity = '3';

INSERT INTO tab_compact_full;

INSERT INTO tab_wide_full;

SELECT
    table,
    part_type
FROM `system`.parts
WHERE database = currentDatabase()
    AND table LIKE 'tab_%'
ORDER BY table ASC;

SELECT
    id,
    str
FROM tab_compact_full
WHERE hasToken(str, 'foo')
LIMIT 3;

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab_compact_full
                WHERE hasToken(str, 'foo')
                LIMIT 3
            ))
    )
WHERE `explain` LIKE '%text%'
    OR `explain` LIKE '%Granules:%';

SELECT
    id,
    str
FROM tab_wide_full
WHERE hasToken(str, 'foo')
LIMIT 3;

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT id
                FROM tab_wide_full
                WHERE hasToken(str, 'foo')
                LIMIT 3
            ))
    )
WHERE `explain` LIKE '%text%'
    OR `explain` LIKE '%Granules:%';

DROP TABLE tab_compact_full;

DROP TABLE tab_wide_full;