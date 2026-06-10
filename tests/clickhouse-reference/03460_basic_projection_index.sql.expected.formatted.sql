-- { echo ON }
SET enable_analyzer = '1';

SET parallel_replicas_local_plan = '1';

SET optimize_aggregation_in_order = '0';

SET min_table_rows_to_use_projection_index = '0';

------------------------------------------------------------------------------
-- 1. Basic projection index behavior (simple table)
------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_proj;

CREATE TABLE t_proj
(
    id UInt64,
    region String,
    user_id UInt32,
    PROJECTION region_proj INDEX region TYPE basic(),
    PROJECTION user_id_proj INDEX user_id TYPE basic()
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '1', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0', enable_vertical_merge_algorithm = '0';

INSERT INTO t_proj;

OPTIMIZE TABLE t_proj FINAL;

-- Pick projection based on both filters
SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_proj
                WHERE region = 'eu'
                    AND user_id = 101
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_proj
WHERE region = 'eu'
    AND user_id = 101
ORDER BY `ALL` ASC;

-- Region only
SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_proj
                WHERE region = 'zzz'
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_proj
WHERE region = 'zzz'
ORDER BY `ALL` ASC;

-- User only
SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_proj
                WHERE user_id = 106
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_proj
WHERE user_id = 106
ORDER BY `ALL` ASC;

-- OR → projection index disabled
SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_proj
                WHERE region = 'asia'
                    OR user_id = 101
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_proj
WHERE region = 'asia'
    OR user_id = 101
ORDER BY `ALL` ASC;

DROP TABLE t_proj;

------------------------------------------------------------------------------
-- 2. Granule edge cases (top/mid/bottom rows hit inside same granule)
------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_gran;

CREATE TABLE t_gran
(
    id UInt64,
    region String,
    PROJECTION region_proj INDEX region TYPE basic()
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '16', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0', enable_vertical_merge_algorithm = '0';

INSERT INTO t_gran;

INSERT INTO t_gran SELECT
    number + 1,
    'other'
FROM numbers(6);

INSERT INTO t_gran;

INSERT INTO t_gran SELECT
    number + 8,
    'other'
FROM numbers(6);

INSERT INTO t_gran;

-- Extra data to ensure projection index is chosen
INSERT INTO t_gran SELECT
    number + 100,
    'zzz'
FROM numbers(1000);

OPTIMIZE TABLE t_gran FINAL;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_gran
                WHERE region = 'top'
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_gran
WHERE region = 'top'
ORDER BY `ALL` ASC;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_gran
                WHERE region = 'mid'
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_gran
WHERE region = 'mid'
ORDER BY `ALL` ASC;

SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_gran
                WHERE region = 'bot'
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_gran
WHERE region = 'bot'
ORDER BY `ALL` ASC;

DROP TABLE t_gran;

------------------------------------------------------------------------------
-- 3. Partial materialization (projection added after data exists)
------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_partial;

CREATE TABLE t_partial
(
    id UInt64,
    region String
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '1', min_bytes_for_wide_part = '0', min_bytes_for_full_part_storage = '0', enable_vertical_merge_algorithm = '0';

INSERT INTO t_partial;

ALTER TABLE t_partial ADD PROJECTION region_proj INDEX region TYPE basic();

INSERT INTO t_partial;

-- Should use projection for rows 4–6 only
SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_partial
                WHERE region = 'ru'
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_partial
WHERE region = 'ru'
ORDER BY `ALL` ASC;

-- CN appears in both partial and full materialized parts
SELECT trimLeft(`explain`)
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'projections = 1', (
                SELECT *
                FROM t_partial
                WHERE region = 'cn'
            ))
    )
WHERE `explain` LIKE '%ReadFromMergeTree%'
    OR match(`explain`, '^\\s+[A-Z][a-z]+(\\s+[A-Z][a-z]+)*:');

SELECT *
FROM t_partial
WHERE region = 'cn'
ORDER BY `ALL` ASC;

DROP TABLE t_partial;

------------------------------------------------------------------------------
-- 4. (Replicated)MergeTree consistency test
------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_repl SYNC;

DROP TABLE IF EXISTS t_repl2 SYNC;

CREATE TABLE t_repl
(
    id UInt64,
    region String,
    PROJECTION region_proj INDEX region TYPE basic()
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test/proj', 'r1')
ORDER BY id;

INSERT INTO t_repl;

CREATE TABLE t_repl2
(
    id UInt64,
    region String,
    PROJECTION region_proj INDEX region TYPE basic()
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/test/proj', 'r2')
ORDER BY id;

SYSTEM SYNC REPLICA t_repl2;

-- check projection part exists on both replicas
SELECT
    table,
    name
FROM `system`.projection_parts
WHERE database = currentDatabase()
    AND table IN ('t_repl', 't_repl2')
ORDER BY `ALL` ASC;

DETACH TABLE t_repl2 SYNC;

ATTACH TABLE t_repl2;

DESCRIBE TABLE mergeTreeProjection(currentDatabase(), t_repl2, region_proj);

DROP TABLE t_repl SYNC;

DROP TABLE t_repl2 SYNC;

------------------------------------------------------------------------------
-- 5. BAD CASES
------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_bad SYNC;

-- Unknown index type
CREATE TABLE t_bad
(
    id UInt64,
    PROJECTION bad INDEX id TYPE unknown_type()
)
ENGINE = MergeTree()
ORDER BY (); -- { serverError INCORRECT_QUERY }

-- Invalid expression inside index
CREATE TABLE t_bad
(
    id UInt64,
    PROJECTION bad INDEX missing TYPE basic()
)
ENGINE = MergeTree()
ORDER BY (); -- { serverError UNKNOWN_IDENTIFIER }