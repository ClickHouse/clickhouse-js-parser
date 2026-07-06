-- Test that the optimizer picks up column statistics
-- (The concrete statistics type, column data type and predicate type don't matter)
-- Checks by the predicate evaluation order in EXPLAIN. This is quite fragile, a better approach would be helpful (maybe 'send_logs_level'?)
SET allow_experimental_statistics = '1';

SET use_statistics = '1';

SET mutations_sync = '1';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    a Float64 STATISTICS(tdigest()),
    b Int64 STATISTICS(tdigest())
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS auto_statistics_types = '';

INSERT INTO tab SELECT
    number,
    -number
FROM `system`.numbers
LIMIT 10000;

SELECT replaceRegexpAll(`explain`, '__table1\\.', '')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT count(*)
                FROM tab
                WHERE b < 10
                    AND a < 10
            ))
    )
WHERE `explain` LIKE '%Prewhere%'; -- checks a first, then b (statistics used)

ALTER TABLE tab DROP STATISTICS a, b;

SELECT
    name,
    column,
    statistics
FROM `system`.parts_columns
WHERE database = currentDatabase()
    AND table = 'tab';

ALTER TABLE tab ADD STATISTICS a, b TYPE tdigest;

ALTER TABLE tab MATERIALIZE STATISTICS ALL;

OPTIMIZE TABLE tab FINAL;

ALTER TABLE tab RENAME COLUMN b TO c;

SELECT replaceRegexpAll(`explain`, '__table1\\.', '')
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'actions = 1', (
                SELECT count(*)
                FROM tab
                WHERE c < 10
                    AND a < 10
            ))
    )
WHERE `explain` LIKE '%Prewhere%'; -- checks a first, then c (statistics used)