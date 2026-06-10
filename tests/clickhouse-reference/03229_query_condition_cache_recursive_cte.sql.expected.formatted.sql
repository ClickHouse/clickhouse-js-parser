-- Tags: no-parallel
-- Tag no-parallel: Messes with internal cache
-- Test for issue #81506 (recursive CTEs return wrong results if the query condition cache is on)
SET allow_experimental_analyzer = '1'; -- needed by recursive CTEs

-- Start from a clean query condition cache
SYSTEM CLEAR QUERY CONDITION CACHE;

SELECT '-- Prepare data';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id String,
    parent String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab (id, parent);

WITH RECURSIVE recursive AS (
    SELECT id
    FROM tab
    WHERE id = 'uuid3'
    UNION ALL
    SELECT parent AS id
    FROM tab
    WHERE tab.id IN (recursive)
        AND parent != 'empty'
    GROUP BY parent
)

SELECT *
FROM recursive
GROUP BY id
ORDER BY id ASC;

DROP TABLE tab;