SET parallel_replicas_local_plan = '1';

-- Test for issue #75523
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt64,
    col Float,
    INDEX col_idx col TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY id; -- This is important. We want to have additional primary index that does not use the column `col`.

INSERT INTO tab;

SELECT count()
FROM tab
WHERE col = nan;

SELECT count()
FROM tab
WHERE col != nan;

SELECT count()
FROM tab
WHERE col = -nan;

SELECT count()
FROM tab
WHERE col != -nan;

SELECT count()
FROM tab
WHERE isNaN(col);

SELECT count()
FROM tab
WHERE NOT isNaN(col);

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE col = nan
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2; -- Skip the primary index parts and granules.

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE col = -nan
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2; -- Skip the primary index parts and granules.

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE col != nan
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2; -- Skip the primary index parts and granules.

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE col != -nan
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Parts:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 3
OFFSET 2; -- Skip the primary index parts and granules.

DROP TABLE tab;